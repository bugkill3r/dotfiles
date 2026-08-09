local M = {}

-- Configure Mason before loading other LSP components
M.setup = function()
  -- Configure Mason installer
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗"
      },
      keymaps = {
        -- Keymap to expand a package
        toggle_package_expand = "<CR>",
        -- Keymap to install the package under the current cursor position
        install_package = "i",
        -- Keymap to reinstall/update the package under the current cursor position
        update_package = "u",
        -- Keymap to check for new version for the package under the current cursor position
        check_package_version = "c",
        -- Keymap to update all installed packages
        update_all_packages = "U",
        -- Keymap to check which installed packages are outdated
        check_outdated_packages = "C",
        -- Keymap to uninstall a package
        uninstall_package = "X",
        -- Keymap to cancel a package installation
        cancel_installation = "<C-c>",
        -- Keymap to apply language filter
        apply_language_filter = "<C-f>",
      },
    },
    
    -- Where Mason should install packages
    install_root_dir = vim.fn.stdpath("data") .. "/mason",
    
    -- Limit concurrent installations
    max_concurrent_installers = 4,
  })

  -- Configure Mason-LSPConfig
  require("mason-lspconfig").setup({
    -- A list of servers to automatically install if they're not already installed
    ensure_installed = {
      "lua_ls",       -- Lua
      "ts_ls",     -- TypeScript/JavaScript (updated from tsserver)
      "rust_analyzer", -- Rust
      "pyright",      -- Python
      "gopls",        -- Go (re-enabled now that Go is installed)
      "jsonls",       -- JSON
      "html",         -- HTML
      "cssls",        -- CSS
      "tailwindcss",  -- Tailwind CSS
      "clangd",       -- C/C++
    },
    -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed
    automatic_installation = true,
    -- Disable automatic_enable which requires Neovim 0.11+ (vim.lsp.enable)
    automatic_enable = false,
  })

  -- Import other LSP modules
  local keymaps = require("bugkill3r.lsp.keymaps")
  local handlers = require("bugkill3r.lsp.handlers")
  
  -- Configure handlers
  handlers.setup()

  -- Common LSP setup across all language servers
  local lsp_defaults = {
    flags = {
      debounce_text_changes = 150,
    },
    capabilities = require("cmp_nvim_lsp").default_capabilities(
      vim.lsp.protocol.make_client_capabilities()
    ),
    on_attach = function(client, bufnr)
      -- Apply keymaps
      keymaps.on_attach(client, bufnr)
      
      -- Disable formatting for certain servers (null-ls will handle it)
      if client.name == "ts_ls" or client.name == "lua_ls" then
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end
    end
  }

  -- Defaults for every server. On Neovim 0.11+ this is vim.lsp.config("*"),
  -- which extends the base configs nvim-lspconfig ships in lsp/<name>.lua —
  -- the old require("lspconfig").util.default_config path is deprecated.
  vim.lsp.config("*", lsp_defaults)

  vim.lsp.config("lua_ls", {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      },
    },
  })

  vim.lsp.config("jsonls", {
    settings = { json = { validate = { enable = true } } },
  })

  -- Rust: rust-tools is abandoned; rust_analyzer is configured directly.
  vim.lsp.config("rust_analyzer", {
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = { command = "clippy" },
      },
    },
  })

  vim.lsp.enable({
    "lua_ls", "ts_ls", "pyright", "gopls",
    "html", "cssls", "jsonls", "rust_analyzer",
  })
end

return M
