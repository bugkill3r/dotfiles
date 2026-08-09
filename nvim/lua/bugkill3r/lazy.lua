-- lazy.nvim bootstrap + plugin spec (migrated from packer.lua)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- formatting / git
  "sbdchd/neoformat",
  "TimUntersberger/neogit",

  -- core libs
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",

  -- telescope + fzf
  "nvim-telescope/telescope.nvim",
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "junegunn/fzf", build = "./install --bin" },
  "junegunn/fzf.vim",

  -- git
  { "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- icons + statusline
  "nvim-tree/nvim-web-devicons",
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  "b0o/schemastore.nvim",

  -- LSP / completion
  "VonHeikemen/lsp-zero.nvim",
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lua",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",
  "saadparwaiz1/cmp_luasnip",
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",
  { "tzachar/cmp-tabnine", build = "./install.sh" },
  "onsails/lspkind.nvim",
  "nvim-lua/lsp_extensions.nvim",
  "nvimdev/lspsaga.nvim",
  "simrat39/symbols-outline.nvim",
  "nvimtools/none-ls.nvim",
  "ray-x/lsp_signature.nvim",
  "lvimuser/lsp-inlayhints.nvim",

  -- jupyter
  "untitled-ai/jupyter_ascending.vim",
  "bfredl/nvim-ipy",
  "GCBallesteros/jupytext.vim",

  -- navigation / editing
  "ThePrimeagen/harpoon",
  "mbbill/undotree",
  "danilamihailov/beacon.nvim",
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "folke/which-key.nvim", config = function() require("which-key").setup({}) end },
  "prichrd/netrw.nvim",
  "eandrju/cellular-automaton.nvim",

  -- treesitter — `master` branch (self-consistent parsers+queries; works with
  -- the classic configs API this repo uses). `main` isn't ready on nvim 0.12.
  -- playground dropped — nvim has :InspectTree / :Inspect built in.
  { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
  "romgrk/nvim-treesitter-context",

  -- DAP
  "mfussenegger/nvim-dap",
  "rcarriga/nvim-dap-ui",
  "theHamsta/nvim-dap-virtual-text",
  "nvim-neotest/nvim-nio",

  -- languages
  "mfussenegger/nvim-jdtls",
  "Saecki/crates.nvim",

  -- AI
  "github/copilot.vim",
  "supermaven-inc/supermaven-nvim",
  {
    "olimorris/codecompanion.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("codecompanion").setup({
        strategies = {
          chat = { adapter = "anthropic" },
          inline = { adapter = "anthropic" },
        },
      })
    end,
  },

  -- colorschemes
  "gruvbox-community/gruvbox",
  "folke/tokyonight.nvim",
  { "rose-pine/neovim", name = "rose-pine" },
  "Yazeed1s/oh-lucy.nvim",
  -- catppuccin pinned to the last release that supports stable nvim 0.12
  -- (newer commits require a nvim-nightly `vim.nonnil` API). Version tag, not
  -- a SHA. Setup + colorscheme + flavor happen in after/plugin/colors.lua.
  { "catppuccin/nvim", name = "catppuccin", version = "v1.11.0", priority = 1000 },
}, {
  install = { colorscheme = { "catppuccin", "habamax" } },
  checker = { enabled = false },
  change_detection = { notify = false },
})
