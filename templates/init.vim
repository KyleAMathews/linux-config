let mapleader = ','

call plug#begin('~/.config/nvim/plugged')

" Color schemes
Plug 'sjl/badwolf'
Plug 'altercation/vim-colors-solarized'
Plug 'sts10/vim-mustard'

" Baseline of settings
Plug 'tpope/vim-sensible'

" File searcher
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" silver searcher integration.
Plug 'rking/ag.vim'

" Show git changes in gutter
Plug 'airblade/vim-gitgutter'

" Good ol' Nerdtree
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Distraction free writing :Goyo
Plug 'junegunn/goyo.vim', { 'for': 'markdown' }

" Async run scripts e.g. eslint
Plug 'neomake/neomake'

" Async run formatters e.g. prettier
Plug 'sbdchd/neoformat'

" Improve terminal support :Term :VTerm
Plug 'vimlab/split-term.vim'

"JavaScript specific
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'elzr/vim-json'
Plug 'moll/vim-node' " gf on requires to jump to its file ❤️

" GUI for undoing mapped to <leader>u
Plug 'sjl/gundo.vim'

" A statusline plugin
Plug 'vim-airline/vim-airline'

" Autocomplete
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ervandew/supertab'

" commenting code
Plug 'scrooloose/nerdcommenter'

call plug#end()

 " ctrl-p file search
nnoremap <C-p> :FZF<CR>
" silver searcher
nnoremap <leader>a :Ag
nmap <leader>n :NERDTreeToggle<cr>

set background=dark
colorscheme solarized 
set colorcolumn=85 " Show a colored column at 85 characters.

set number " show line numbers in the gutter.
set relativenumber " numbers are relative to the cursor.
set cursorline " highlight current line as easier to find it.
set nowrap " Don't wrap long lines.
set tabstop=2 " number of visual spaces per TAB
set expandtab " tabs are spaces
set smartindent
set autoindent
set showmatch " highlight matching [{()}]
set wildmenu " visual autocomplete for the command menu.
filetype plugin indent on      " load filetype-specific indent files
set lazyredraw          " redraw only when we need to e.g. not in middle of macro.

" Strip all trailing whitespace in the current file
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Map jj to <ESC> to make it easier to move to normal mode
inoremap jj <ESC>

" toggle gundo
nnoremap <leader>u :GundoToggle<CR>

" Make it easier to work with split windows

" Open a new vertical split and switch to it
nnoremap <leader>w <C-w>v<C-w>l

" Open a new horizontal split and switch to it
nnoremap <leader>h <C-w>s<C-w>l

" Hack to get C-h working in neovim
if has('nvim')
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  nmap <BS> <C-W>h
  tnoremap <Esc> <C-\><C-n>
endif

" Map Ctrl plus normal navigation keys to move around splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-=> <C-w>=

" Create an undo file for each file edited.
set undofile

set incsearch           " search as characters are entered
set hlsearch            " highlight matches
nnoremap <leader><space> :noh<cr> " Clear out search

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Make Tab work for switching between matching bracket pairs
nnoremap <tab> %
vnoremap <tab> %

" NerdCommenter
let g:NERDSpaceDelims = 1 " add space after comment delimiter

function! EscapeString (string)
  let string=a:string
  " Escape regex characters
  let string = escape(string, '^$.*\/~[]')
  " Escape the line endings
  let string = substitute(string, '\n', '\\n', 'g')
  return string
endfunction

" Get the current visual block for search and replaces
" This function passed the visual block through a string escape function
" Based on this - http://stackoverflow.com/questions/676600/vim-replace-selected-text/677918#677918
function! GetVisual() range
  " Save the current register and clipboard
  let reg_save = getreg('"')
  let regtype_save = getregtype('"')
  let cb_save = &clipboard
  set clipboard&

  " Put the current visual selection in the " register
  normal! ""gvy
  let selection = getreg('"')

  " Put the saved registers and clipboards back
  call setreg('"', reg_save, regtype_save)
  let &clipboard = cb_save

  "Escape any special characters in the selection
  let escaped_selection = EscapeString(selection)

  return escaped_selection
endfunction

" Start the find and replace command across the entire file
vmap <leader>z <Esc>:%s/<c-r>=GetVisual()<cr>/

" map ; to :
nmap ; :

" Javascript stuff
" Set tabs to two spaces for javascript
au FileType javascript setl sw=2 sts=2 expandtab
let g:neoformat_javascript_prettier = {
          \ 'exe': 'prettier',
          \ 'args': ['--stdin', '--trailing-comma es5'],
          \ 'stdin': 1,
          \ }
let g:neoformat_enabled_javascript = ['prettier']
"neoformat: format javascript on save
autocmd BufWritePre *.js Neoformat " Run Prettier on save.
autocmd BufWritePre *.jsx Neoformat

let g:neomake_javascript_enabled_makers = ['eslint']
autocmd! BufWritePost * Neomake " Run eslint on close

" vim-javascript
let g:javascript_plugin_flow = 1
let g:javascript_plugin_jsdoc = 1

" Respect .gitignore by getting list of files from silver searcher
" which has code built-in for looking at .gitignore.
let $FZF_DEFAULT_COMMAND = 'ag -g ""'

" Enable true color
let $NVIM_TUI_ENABLE_TRUE_COLOR=1

" Python setup for mac
let g:python2_host_prog = '/usr/local/bin/python'
let g:python3_host_prog = '/usr/local/bin/python3'
