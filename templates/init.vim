let mapleader = ','

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" surround plugin
Plug 'https://tpope.io/vim/surround.git'

" Color schemes
Plug 'sjl/badwolf'
Plug 'altercation/vim-colors-solarized'
Plug 'sts10/vim-mustard'
Plug 'fatih/molokai'
Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

" highlight color values in code.
Plug 'norcalli/nvim-colorizer.lua'

" Make LSP diagnostic colors work better for older color schemes
Plug 'folke/lsp-colors.nvim'

" Add Trouble plugin for better display of diagnostic info
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'

" LSP
Plug 'anott03/nvim-lspinstall'
Plug 'neovim/nvim-lspconfig'
" Plug 'nvimdev/lspsaga.nvim'

" vsnip.
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

" Auto complete
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

" File finder
" Plug 'camspiers/snap'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'branch': '0.1.x' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'

" A statusline plugin
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" enable showing buffers in tab nav
let g:airline#extensions#tabline#enabled = 1

" commenting code
Plug 'scrooloose/nerdcommenter'

" Git/GitHub helpers
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

call plug#end()


let g:gruvbox_contrast_dark = 'hard'
colorscheme gruvbox
set background=dark
set colorcolumn=85 " Show a colored column at 85 characters.

" Enable true color
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

set number " show line numbers in the gutter.
set relativenumber " numbers are relative to the cursor.
set cursorline " highlight current line as easier to find it.
set nowrap " Don't wrap long lines.
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " Number of spaces to add instead of a tab
set expandtab " tabs are spaces
set shiftwidth=2 " an autoindent (with <<) is two spaces
set list " Show invisible characters
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

" Edit file at the current buffers directory
nmap <leader>ew :e <C-R>=expand('%:h').'/'<cr>

" Make it easier to work with split windows

" Open a new vertical split and switch to it
nnoremap <leader>w <C-w>v<C-w>l

" Open a new horizontal split and switch to it
nnoremap <leader>h <C-w>s<C-w>l

" Map Ctrl plus normal navigation keys to move around splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-=> <C-w>=

" Create an undo file for each file edited.
set undofile

" Search config
set incsearch           " search as characters are entered
set hlsearch            " highlight matches
set ignorecase " case insensitive search...
set smartcase   " ... unless they contain at least one capital letter
nnoremap <leader><space> :noh<cr> " Clear out search

" move vertically by visual line
nnoremap j gj
nnoremap k gk

" Make Tab work for switching between matching bracket pairs
nnoremap <tab> %
vnoremap <tab> %

" map ; to :
nmap ; :

" completion
lua <<EOF
-- Set up nvim-cmp.
local cmp = require'cmp'


cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require('lspconfig')['tailwindcss'].setup {
  capabilities = capabilities
}
require('lspconfig')['tsserver'].setup {
  capabilities = capabilities
}
require('lspconfig')['efm'].setup {
  capabilities = capabilities
}
EOF

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

"" Setup tailwindcss lsp
lua require'lspconfig'.tailwindcss.setup{}

lua <<EOF
require 'colorizer'.setup {
  'css';
  'javascript';
  html = {
    mode = 'foreground';
  }
}
EOF

"" Treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = false,
    },
    ensure_installed = {'javascript'}
}
EOF

"" Snap
" lua <<EOF
" local snap = require'snap'

" local fzf = snap.get'consumer.fzf'
" local limit = snap.get'consumer.limit'
" local producer_file = snap.get'producer.ripgrep.file'
" local producer_vimgrep = snap.get'producer.ripgrep.vimgrep'
" local producer_buffer = snap.get'producer.vim.buffer'
" local producer_oldfile = snap.get'producer.vim.oldfile'
" local select_file = snap.get'select.file'
" local select_vimgrep = snap.get'select.vimgrep'
" local preview_file = snap.get'preview.file'
" local preview_vimgrep = snap.get'preview.vimgrep'

" snap.register.map({'n'}, {'<Leader><Leader>'}, function ()
  " snap.run({
    " prompt = 'Files',
    " producer = fzf(producer_file),
    " select = select_file.select,
    " multiselect = select_file.multiselect,
    " views = {preview_file}
  " })
" end)

" snap.register.map({'n'}, {'<Leader>ff'}, function ()
  " snap.run({
    " prompt = 'Grep',
    " producer = limit(10000, producer_vimgrep),
    " select = select_vimgrep.select,
    " multiselect = select_vimgrep.multiselect,
    " views = {preview_vimgrep}
  " })
" end)

" snap.register.map({'n'}, {'<Leader>fb'}, function ()
  " snap.run({
    " prompt = 'Buffers',
    " producer = fzf(producer_buffer),
    " select = select_file.select,
    " multiselect = select_file.multiselect,
    " views = {preview_file}
  " })
" end)

" snap.register.map({'n'}, {'<Leader>fo'}, function ()
  " snap.run({
    " prompt = 'Oldfiles',
    " producer = fzf(producer_oldfile),
    " select = select_file.select,
    " multiselect = select_file.multiselect,
    " views = {preview_file}
  " })
" end)

" snap.register.map({'n'}, {'<Leader>m'}, function ()
  " snap.run({
    " prompt = 'Grep',
    " producer = limit(10000, producer_vimgrep),
    " select = select_vimgrep.select,
    " multiselect = select_vimgrep.multiselect,
    " initial_filter = vim.fn.expand('<cword>')
  " })
" end)
" EOF

" Find files using Telescope command-line sugar.
nnoremap <leader><leader> <cmd>Telescope find_files<cr>
nnoremap <leader>ff <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>


lua << EOF
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').setup{
  pickers = {
    find_files = {
      find_command = { "fd", "--hidden", "--type", "file" },
    },
  }
}
require('telescope').load_extension('fzf')

local lspconfig = require'lspconfig'

-- npm i -g eslint_d
-- brew install efm-langserver 
local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatStdin = true
}

local prettier = {
 formatCommand = "prettier --stdin-filepath ${INPUT}",
 formatStdin = true,
}

local function eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslint*", 0, 1)

  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false
end

vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then
        return
    end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end

-- You will likely want to reduce updatetime which affects CursorHold
-- note: this setting is global and should be set only once
vim.o.updatetime = 250
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

local on_attach = function(client)
    local au = vim.api.nvim_create_autocmd
    local ag = vim.api.nvim_create_augroup
    local clear_au = vim.api.nvim_clear_autocmds

    -- Autoformat on save
    local augroup = ag("LspFormatting", { clear = false })
    if client.supports_method("textDocument/formatting") then
        au("BufWritePre", {
            clear_au({ group = augroup, buffer = bufnr }),
            group = augroup,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
        })
    end

    -- Show diagnostics in hoverbox if cursor pauses on underlined text
    vim.api.nvim_create_autocmd("CursorHold", {
      buffer = bufnr,
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = 'rounded',
          source = 'always',
          prefix = ' ',
          scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
      end
    })
end

vim.diagnostic.config({
  virtual_text = {
    source = "always",  -- Or "if_many"
  },
  float = {
    source = "always",  -- Or "if_many"
  },
})

lspconfig.tsserver.setup {
    on_attach = function(client)
        -- Disable to avoid conflicts with prettier
        client.server_capabilities.documentFormattingProvider = false
        on_attach(client)
    end
}

--[[
  on_attach = on_attach,
  
  root_dir = function()
    if not eslint_config_exists() then
      return nil
    end
    return vim.fn.getcwd()
  end,
  --]]
lspconfig.efm.setup{
  on_attach = on_attach,
  init_options = {documentFormatting = true},
  settings = {
    rootMarkers = {".git/"},
    languages = {
      javascript = {eslint},
      javascriptreact = {eslint},
      ["javascript.jsx"] = {eslint},
      typescript = {eslint},
      ["typescript.tsx"] = {eslint},
      typescriptreact = {eslint},
      markdown = {eslint},
      json = {prettier},
    },
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
    "markdown",
    "json",
  },
}
EOF

" Setup Trouble plugin
lua << EOF
  require("trouble")--.setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
 -- }
EOF


" " Setup Navigator plugin
" lua <<EOF
" require'navigator'.setup()
" EOF
