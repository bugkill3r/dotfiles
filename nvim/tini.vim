set nu
set relativenumber

set termguicolors
set t_Co=256

" Plugins will be downloaded under the specified directory.
call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

" Plugins

" Plug 'tpope/vim-sensible'
"Plug 'junegunn/seoul256.vim'

Plug 'tpope/vim-fugitive'
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Color schemes

Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

colorscheme tokyonight-night

lua require'nvim-treesitter.configs'.setup{highlight={enable=true}}

lua require 'lualine'.setup()

lua require'nvim-treesitter.configs'.setup { sync_install = true }
