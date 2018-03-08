if &compatible
  set nocompatible
endif

" Plugins {{{
" Required:
call plug#begin('~/.vim/plugged')

" Let Plug manage dein
" Required:
Plug '~/.config/nvim/plugged//repos/github.com/Shougo/dein.vim'

" File Tree
Plug 'scrooloose/nerdtree'
" Fuzzy search
Plug 'ctrlpvim/ctrlp.vim'

" (Un)comment lines
Plug  'scrooloose/nerdcommenter'
" Align stuff
Plug  'junegunn/vim-easy-align'
" End some structures (if, do, def, ....)
Plug  'tpope/vim-endwise'
" Close quotes, parenthesis, brackets, ...
Plug  'Raimondi/delimitMate'
" Change quotes, parenthesis, brackets, ...
Plug  'tpope/vim-surround'

" Completion
Plug  'Valloric/YouCompleteMe'

" Repeat map instead of command
Plug  'tpope/vim-repeat'

" Colors
Plug  'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
" Status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax highlighting
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'slim-template/vim-slim'

" Required:
call plug#end()

" Required:
filetype plugin indent on
syntax enable
" }}}

" Leader
let mapleader = ","
let maplocalleader=","

" Colors
colorscheme Tomorrow-Night-Eighties

" User Interface {{{
set cursorline
set laststatus=2
set list
set listchars=trail:·
set nowrap
set number
set numberwidth=4
set ruler
set scrolloff=8
set showcmd
set showmatch
set splitbelow
set splitright
set textwidth=0
set visualbell
set wildmenu
" }}}
" Behavior {{{
set autoread
set backspace=indent,eol,start
set hidden
set history=100
set shell=/bin/zsh
set ttimeoutlen=50
set wildignore=.svn,CVS,.git,.hg,*.o,*.a,*.class,*.obj,*.jpg,*.png,*.gif
set mouse=a
" }}}
" Indentation {{{
set autoindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2
set tabstop=8
" }}}
" Searching {{{
set incsearch
set hlsearch
set ignorecase
set smartcase
nnoremap / /\v
vnoremap / /\v
" }}}

" Backups and undos
set nobackup
set noswapfile

" Encoding
set encoding=utf-8
set fileencoding=utf-8

" Copy/paste with shared clipboard
set clipboard=unnamed

" Folding
set foldenable
set foldlevelstart=0
set foldmethod=marker

" Wrapping
set wrap linebreak nolist

" Clear searches
nmap <silent> <C-l> :silent noh<CR>

" Keep selection after in/outdent
vnoremap < <gv
vnoremap > >gv

" Better navigation of wrapped lines
nnoremap j gj
nnoremap k gk

" Easier increment/decrement
nnoremap - <C-a>
nnoremap + <C-x>

" Easy split navigation
nnoremap <C-w><C-h> <C-w>h
nnoremap <C-w><C-j> <C-w>j
nnoremap <C-w><C-k> <C-w>k
nnoremap <C-w><C-l> <C-w>l

" Go to first and last character of line
noremap H ^
noremap L g_

" Ignore K
nnoremap K <nop>

" Easier escaping from insert modus
inoremap jk <esc>
inoremap Jk <esc>
inoremap JK <esc>

" Map semicolon to colon
nnoremap ; :

" Space to toggle folds
nnoremap <Space> za
vnoremap <Space> za

" Splits
map <Leader>s :split<CR>
map <Leader>v :vsplit<CR>

" Place newlines with enter
nmap <Enter> o<Esc>

" NerdTree
nmap <leader>p :NERDTreeFind<CR>
" CtrlP
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/node_modules/*
" Pandoc
let g:pandoc#modules#disabled = ["folding", "spell"]
augroup pandoc_syntax
  au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'

" Create parent directories {{{
augroup BWCCreateDir
  au!
  function! s:MkNonExDir(file, buf)
    if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
      let dir=fnamemodify(a:file, ':h')
      if !isdirectory(dir)
        call mkdir(dir, 'p')
      endif
    endif
  endfunction
  au BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END
" }}}
" Remove trailing whitespaces {{{
augroup TrailingWS
  au!
  function! s:rmTrWhiteSpace()
    normal! ma
    :%s/\s\+$//e
    normal! `a
  endfunction
  au BufWritePre * :call s:rmTrWhiteSpace()
augroup END
" }}}


