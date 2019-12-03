set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" my custom plugins
Plugin 'Valloric/YouCompleteMe'
"Plugin 'bling/vim-airline'

" Python plugins and setup
Plugin 'tmhedberg/SimpylFold'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'airblade/vim-gitgutter'

set encoding=utf-8

let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

let python_highlight_all=1
syntax on

"python with virtualenv support
py << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF


" File Browsing
Plugin 'scrooloose/nerdtree'
" Close if no active buffers
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Automatically start NERDTree 
autocmd vimenter * NERDTree

" Focus on the editing window by default rather than NERDTree window
autocmd VimEnter * wincmd p

" Automatically start NERDTree if no files were specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

Plugin 'kien/ctrlp.vim'

set nu

Plugin 'tpope/vim-fugitive'

"Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}
"let g:Powerline_symbols = 'fancy'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'


au BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix


" Full stack development 
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

" add all your plugins here (note older versions of Vundle
" used Bundle instead of Plugin)

" ...

" Color Schemes
Plugin 'altercation/vim-colors-solarized'
let g:solarized_termcolors=256
syntax enable
set background=dark
colorscheme solarized
"Plugin 'jnurmine/Zenburn'

"if has('gui_running')
"  set background=dark
"  colorscheme solarized
"else
"  colorscheme zenburn
"endif


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" Other setup

" To fold code snippets
set foldmethod=indent
set foldlevel=99

" Key mappings
"
nnoremap <space> za
nnoremap c :bp\|bd #<CR>

