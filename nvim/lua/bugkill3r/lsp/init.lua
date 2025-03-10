M = {}
local ok, _ = pcall(require, "lspconfig")
if not ok then
    return
end

M.server_capabilities = function()
  local active_clients = vim.lsp.get_active_clients()
  local active_client_map = {}

  for index, value in ipairs(active_clients) do
    active_client_map[value.name] = index
  end

  vim.ui.select(vim.tbl_keys(active_client_map), {
    prompt = "Select client:",
    format_item = function(item)
      return "capabilites for: " .. item
    end,
  }, function(choice)
    -- print(active_client_map[choice])
    print(vim.inspect(vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities.executeCommandProvider))
    vim.pretty_print(vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities)
  end)
end

require "bugkill3r.lsp.lsp-signature"
require "bugkill3r.lsp.mason"
require("bugkill3r.lsp.handlers").setup()
require "bugkill3r.lsp.null-ls"

-- require("bugkill3r.lsp.languages.rust")
-- require("bugkill3r.lsp.languages.go")
-- require("bugkill3r.lsp.languages.python")
-- require("bugkill3r.lsp.languages.js-ts")
--
-- lvim.format_on_save = false
-- lvim.lsp.diagnostics.virtual_text = false
--
-- -- if you don't want all the parsers change this to a table of the ones you want
-- lvim.builtin.treesitter.ensure_installed = {
--   "java",
-- }
--
-- vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })
--
-- local formatters = require "lvim.lsp.null-ls.formatters"
-- formatters.setup {
--   { command = "google_java_format", filetypes = { "java" } },
--   { command = "stylua", filetypes = { "lua" } },
-- }
--
-- -- lvim.lsp.on_attach_callback = function(client, bufnr)
-- -- end
--
-- -- local linters = require "lvim.lsp.null-ls.linters"
-- -- linters.setup {
-- --   { command = "eslint_d", filetypes = { "javascript" } },
-- -- }
