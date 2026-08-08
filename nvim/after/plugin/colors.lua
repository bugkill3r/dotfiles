-- follow the unified `theme` switcher's catppuccin flavor (mocha/macchiato/…)
local flavour = "macchiato"
local fh = io.open(vim.fn.expand("~/.config/catppuccin-flavor"), "r")
if fh then
	local l = fh:read("*l"); fh:close()
	if l and #l > 0 then flavour = l:gsub("%s+", "") end
end

require("catppuccin").setup({
	flavour = flavour,
	transparent_background = false,
});

vim.g.bugkill3r_colorscheme = "catppuccin"  -- was "rose-pine"; now matches the theme switcher

function ColorMyPencils()
    vim.g.gruvbox_contrast_dark = 'hard'
    vim.g.tokyonight_transparent_sidebar = true
    vim.g.tokyonight_transparent = true
    vim.g.gruvbox_invert_selection = '0'
    vim.opt.background = "dark"

    vim.cmd("colorscheme " .. vim.g.bugkill3r_colorscheme)

    local hl = function(thing, opts)
        vim.api.nvim_set_hl(0, thing, opts)
    end

    hl("SignColumn", {
        bg = "none",
    })

    hl("ColorColumn", {
        ctermbg = 0,
        bg = "#555555",
    })

    hl("CursorLineNR", {
        bg = "None"
    })

    hl("Normal", {
        bg = "none"
    })

    hl("LineNr", {
        fg = "#5eacd3"
    })

    hl("netrwDir", {
        fg = "#5eacd3"
    })

end
ColorMyPencils()

