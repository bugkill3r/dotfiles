local M = {}

-- M.capabilities = vim.lsp.protocol.make_client_capabilities()
--
-- local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
-- if not status_cmp_ok then
--     return
-- end
-- M.capabilities.textDocument.completion.completionItem.snippetSupport = true
-- M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

-- TODO: backfill this to template
M.setup = function()
    -- Define diagnostic signs using the modern approach
    vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    })

    -- Set sign icons using the new vim.diagnostic namespace
    local signs = {
        Error = "",
        Warn = "",
        Hint = "",
        Info = "",
    }
    
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

local function lsp_highlight_document(client)
    -- This functionality has been moved to keymaps.lua
    -- This function is kept for backward compatibility
end

local function lsp_keymaps(bufnr)
    -- We're using the more comprehensive keymaps from keymaps.lua instead
    -- This function is kept for backward compatibility but doesn't set any keys
end

M.on_attach = function(client, bufnr)
    -- These functions are kept for backward compatibility but don't do anything
    lsp_keymaps(bufnr)
    lsp_highlight_document(client)

    -- Let keymaps.lua handle the keybindings
    local keymaps = require("bugkill3r.lsp.keymaps")
    keymaps.on_attach(client, bufnr)

    -- Disable formatting for specific servers (null-ls will handle it)
    if client.name == "ts_ls" then
        client.server_capabilities.documentFormattingProvider = false
    end

    if client.name == "jdt.ls" then
        if JAVA_DAP_ACTIVE then
            require("jdtls").setup_dap { hotcodereplace = "auto" }
            require("jdtls.dap").setup_dap_main_class_configs()
        end
        client.server_capabilities.documentFormattingProvider = false
    end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not ok then
    return
end

M.capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

return M
