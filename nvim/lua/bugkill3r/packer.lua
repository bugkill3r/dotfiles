return require("packer").startup(function()
    use("wbthomason/packer.nvim")
    use("sbdchd/neoformat")

    -- Simple plugins can be specified as strings
    use("TimUntersberger/neogit")

    -- TJ created lodash of neovim
    use("nvim-lua/plenary.nvim")
    use("nvim-lua/popup.nvim")
    use("nvim-telescope/telescope.nvim")

    use({
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    })

    -- All the things
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},
            {'williamboman/mason.nvim'},
            {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'},
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-path'},
            {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lua'},

            -- Snippets
            {'L3MON4D3/LuaSnip'},
            {'rafamadriz/friendly-snippets'},
        }
    }
    use("neovim/nvim-lspconfig")
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("hrsh7th/nvim-cmp")

    use("hrsh7th/cmp-nvim-lsp-signature-help")
    use("hrsh7th/cmp-nvim-lua")
    use("hrsh7th/cmp-path")
    use("hrsh7th/cmp-vsnip")
    use("hrsh7th/vim-vsnip")


    use("tzachar/cmp-tabnine", { run = "./install.sh" })
    use("onsails/lspkind-nvim")
    use("nvim-lua/lsp_extensions.nvim")
    use("glepnir/lspsaga.nvim")
    use("simrat39/symbols-outline.nvim")
    use("L3MON4D3/LuaSnip")
    use("saadparwaiz1/cmp_luasnip")


    --testing lsp
    use("williamboman/mason.nvim") -- simple to use language server installer
    use("williamboman/mason-lspconfig.nvim") -- simple to use language server installe

    -- Testing out jupyter ascending
    use('untitled-ai/jupyter_ascending.vim')
    use('bfredl/nvim-ipy')
    use('GCBallesteros/jupytext.vim')
    --    use('GCBallesteros/vim-textobj-hydrogen')

    --    use("ThePrimeagen/git-worktree.nvim")
    use("ThePrimeagen/harpoon")

    use("mbbill/undotree")

    -- Colorscheme section
    use("gruvbox-community/gruvbox")
    use("folke/tokyonight.nvim")
    use({"catppuccin/nvim", as = "catppuccin" })
    use({"rose-pine/neovim", as = "rose-pine" })
    use("Yazeed1s/oh-lucy.nvim")

    use("nvim-treesitter/nvim-treesitter", {
        run = ":TSUpdate"
    })

    use("nvim-treesitter/playground")
    use("romgrk/nvim-treesitter-context")

    use("mfussenegger/nvim-dap")
    use("rcarriga/nvim-dap-ui")
    use("theHamsta/nvim-dap-virtual-text")

    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup()
        end
    }

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        },
        tag = 'nightly' -- optional, updated every week. (see issue #1193)
    }

    use("danilamihailov/beacon.nvim")


    -- Java
    use("mfussenegger/nvim-jdtls")


    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }

    use ('simrat39/rust-tools.nvim')


    use ('eandrju/cellular-automaton.nvim')
    use ('prichrd/netrw.nvim')

    use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
    use "ray-x/lsp_signature.nvim"
    -- use {
    --     "zbirenbaum/copilot.lua",
    --     event = { "VimEnter" },
    --     config = function()
    --         vim.defer_fn(function()
    --             require "bugkill3r.copilot"
    --         end, 100)
    --     end,
    -- }
    use "lvimuser/lsp-inlayhints.nvim"
    use "Saecki/crates.nvim"

    use "github/copilot.vim"

    use "onsails/lspkind.nvim"

    use "supermaven-inc/supermaven-nvim"

    use "nvim-neotest/nvim-nio"

    --[[
    --
    -- Lazy loading:
    -- Load on specific commands
    use {'tpope/vim-dispatch', opt = true, cmd = {'Dispatch', 'Make', 'Focus', 'Start'}}

    -- Load on an autocommand event
    use {'andymass/vim-matchup', event = 'VimEnter'}

    -- Load on a combination of conditions: specific filetypes or commands
    -- Also run code after load (see the "config" key)
    use {
        'w0rp/ale',
        ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
        cmd = 'ALEEnable',
        config = 'vim.cmd[[ALEEnable]]--[['
    }

    -- Plugins can have dependencies on other plugins
    use {
        'haorenW1025/completion-nvim',
        opt = true,
        requires = {{'hrsh7th/vim-vsnip', opt = true}, {'hrsh7th/vim-vsnip-integ', opt = true}}
    }

    -- Plugins can also depend on rocks from luarocks.org:
    use {
        'my/supercoolplugin',
        rocks = {'lpeg', {'lua-cjson', version = '2.1.0'}}
    }

    -- You can specify rocks in isolation
    use_rocks 'penlight'
    use_rocks {'lua-resty-http', 'lpeg'}

    -- Local plugins can be included
    use '~/projects/personal/hover.nvim'

    -- Plugins can have post-install/update hooks
    use {'iamcco/markdown-preview.nvim', run = 'cd app && yarn install', cmd = 'MarkdownPreview'}

    -- Post-install/update hook with neovim command
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

    -- Post-install/update hook with call of vimscript function with argument
    use { 'glacambre/firenvim', run = function() vim.fn['firenvim#install'](0) end }

    -- Use specific branch, dependency and run lua file after load
    use {
        'glepnir/galaxyline.nvim', branch = 'main', config = function() require'statusline' end,
        requires = {'kyazdani42/nvim-web-devicons'}
    }

    -- Use dependency and run lua function after load
    use {
        'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
        config = function() require('gitsigns').setup() end
    }

    -- You can specify multiple plugins in a single call
    use {'tjdevries/colorbuddy.vim', {'nvim-treesitter/nvim-treesitter', opt = true}}

    -- You can alias plugin names
    use {'dracula/vim', as = 'dracula'}
end)
--]]
end)

