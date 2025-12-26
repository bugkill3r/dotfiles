-- fzf.lua: Configuration for FZF in Neovim

-- Base FZF options
vim.g.fzf_layout = {
    window = {
        width = 0.9,
        height = 0.8,
        border = 'rounded'
    }
}

-- Use ripgrep if available
if vim.fn.executable('rg') == 1 then
    vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
end

-- FZF colors that match the color scheme
vim.g.fzf_colors = {
    ['fg'] = {'fg', 'Normal'},
    ['bg'] = {'bg', 'Normal'},
    ['hl'] = {'fg', 'Comment'},
    ['fg+'] = {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
    ['bg+'] = {'bg', 'CursorLine', 'CursorColumn'},
    ['hl+'] = {'fg', 'Statement'},
    ['info'] = {'fg', 'PreProc'},
    ['border'] = {'fg', 'Ignore'},
    ['prompt'] = {'fg', 'Conditional'},
    ['pointer'] = {'fg', 'Exception'},
    ['marker'] = {'fg', 'Keyword'},
    ['spinner'] = {'fg', 'Label'},
    ['header'] = {'fg', 'Comment'}
}

-- Key mappings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Files finder
map('n', '<leader>ff', ':Files<CR>', opts)
-- Git files
map('n', '<leader>fg', ':GFiles<CR>', opts)
-- Buffers
map('n', '<leader>fb', ':Buffers<CR>', opts)
-- Grep with ripgrep
map('n', '<leader>fr', ':Rg<CR>', opts)
-- Search in current buffer
map('n', '<leader>fl', ':BLines<CR>', opts)
-- Commands finder
map('n', '<leader>fc', ':Commands<CR>', opts)
-- Search history
map('n', '<leader>fh', ':History/<CR>', opts)

return {} 