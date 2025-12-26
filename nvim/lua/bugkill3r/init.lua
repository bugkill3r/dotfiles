require("bugkill3r.set")
require("bugkill3r.packer")
require("bugkill3r.debugger")

-- lsp
require("bugkill3r.cmp")
require("bugkill3r.lsp").setup()
require("bugkill3r.icons")
require("bugkill3r.dap")
require("bugkill3r.rt")
require("bugkill3r.fzf")
require("bugkill3r.gitsigns")

local augroup = vim.api.nvim_create_augroup
bugkill3rGroup = augroup('bugkill3r', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})


-- group all in one, with multiple patterns
--
-- autocmd({"BufEnter", "BufWinEnter", "TabEnter"}, {
--     group = bugkill3rGroup,
--     pattern = "*.rs",
--     callback = function()
--         require("lsp_extensions").inlay_hints{}
--     end
-- })

autocmd({"BufEnter", "BufWinEnter", "TabEnter"}, {
    group = bugkill3rGroup,
    pattern = "*.java",
    callback = function ()
        require("lsp_extensions").inlay_hints{}
    end
})

autocmd({"BufEnter", "BufWinEnter", "TabEnter"}, {
    group = bugkill3rGroup,
    pattern = "*.py",
    callback = function()
        require("lsp_extensions").inlay_hints{}
    end
})
autocmd({"BufWritePre"}, {
    group = bugkill3rGroup,
    pattern = "*",
    command = "%s/\\s\\+$//e",
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
