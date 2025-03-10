local lsp_zero = require("lsp-zero")

lsp_zero.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }

    if client.name == "eslint" then
        vim.cmd.LspStop("eslint")
        return
    end

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
end)

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "eslint",
        "rust_analyzer",
        "ts_ls"
    },
    automatic_installation = true,
})

local lspconfig = require("lspconfig")

lspconfig.ts_ls.setup({})
lspconfig.eslint.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

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
        {name = 'nvim_lsp'},
        {name = 'buffer'},
    }
})

lsp_zero.setup()

vim.diagnostic.config({
    virtual_text = true,
})


-- local lsp = require("lsp-zero")
--
-- lsp.preset("recommended")
--
-- -- lsp.ensure_installed({
--     --  'tsserver',
--     -- 'eslint',
--     -- 'rust_analyzer',
--     -- })
--
-- require('mason').setup()
-- require('mason-lspconfig').setup({
--     ensure_installed = { 'lua_ls', 'ts_ls', 'eslint', 'rust_analyzer' }
-- })
--
-- -- Fix Undefined global 'vim'
-- lsp.configure('lua_ls', {
--     settings = {
--         Lua = {
--             diagnostics = {
--                 globals = { 'vim' }
--             }
--         }
--     }
-- })
--
-- local cmp = require('cmp')
-- local lspkind = require('lspkind')
-- local cmp_select = {behavior = cmp.SelectBehavior.Select}
-- local cmp_mappings = lsp.defaults.cmp_mappings({
--   ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
--   ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
--   ['<C-y>'] = cmp.mapping.confirm({ select = true }),
--   ["<C-Space>"] = cmp.mapping.complete(),
-- })
--
-- local cmp_formatting = lspkind.cmp_format({
--   mode = 'symbol',
--   maxwidth = 50,
--   ellipsis_char = '...',
--   before = function (entry, vim_item)
--     vim_item.kind = lspkind.presets.default[vim_item.kind]
--     return vim_item
--   end
-- })
--
-- -- disable completion with tab
-- -- this helps with copilot setup
-- cmp_mappings['<Tab>'] = nil
-- cmp_mappings['<S-Tab>'] = nil
--
-- lsp.setup_nvim_cmp({
--   mapping = cmp_mappings,
--   formatting = cmp_formatting
-- })
--
-- lsp.set_preferences({
--     suggest_lsp_servers = false,
--     sign_icons = {
--         error = 'E',
--         warn = 'W',
--         hint = 'H',
--         info = 'I'
--     }
-- })
--
-- lsp.on_attach(function(client, bufnr)
--   local opts = {buffer = bufnr, remap = false}
--
--   if client.name == "eslint" then
--       vim.cmd.LspStop('eslint')
--       return
--   end
--
--   vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
--   vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
--   vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
--   vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
--   vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
--   vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
--   vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
--   vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
--   vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
--   vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
-- end)
--
-- lsp.setup()
--
-- vim.diagnostic.config({
--     virtual_text = true,
-- })
