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

  -- Register lspconfig defaults
  local lspconfig = require('lspconfig')
  lspconfig.util.default_config = vim.tbl_deep_extend(
    'force',
    lspconfig.util.default_config,
    lsp_defaults
  )

  -- Lua LSP configuration
  lspconfig.lua_ls.setup {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  }

  -- TypeScript/JavaScript
  lspconfig.ts_ls.setup {}

  -- Python
  lspconfig.pyright.setup {}

  -- Go
  lspconfig.gopls.setup {}

  -- HTML
  lspconfig.html.setup {}

  -- CSS
  lspconfig.cssls.setup {}

  -- JSON
  lspconfig.jsonls.setup {
    settings = {
      json = {
        validate = { enable = true },
      },
    },
  }

  -- Rust (using rust-tools for better integration)
  require('rust-tools').setup({
    server = {
      on_attach = keymaps.on_attach,
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    },
  })
end

return M
