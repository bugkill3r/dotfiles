-- Native LSP for Neovim 0.11+ (vim.lsp.config / vim.lsp.enable) — no lsp-zero,
-- no direct require("lspconfig") (both are deprecated on 0.11+).

-- Keymaps whenever a language server attaches to a buffer.
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(e)
        local opts = { buffer = e.buf, remap = false }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
    end,
})

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "eslint", "rust_analyzer", "ts_ls" },
    automatic_installation = true,
    automatic_enable = false, -- we enable explicitly below
})

-- Completion capabilities applied to every server (nvim-lspconfig ships the
-- base lsp/<name>.lua configs that vim.lsp.config extends).
local ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_lsp then
    vim.lsp.config("*", { capabilities = cmp_lsp.default_capabilities() })
end

vim.lsp.config("lua_ls", {
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})

-- eslint stays installed (mason) but isn't started as an LSP, matching the old
-- behaviour where it was stopped on attach.
vim.lsp.enable({ "lua_ls", "ts_ls", "rust_analyzer" })

-- Completion.
local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }
cmp.setup({
    mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
    },
})

vim.diagnostic.config({ virtual_text = true })
