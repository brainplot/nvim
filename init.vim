let mapleader = "\<Space>"
set foldmethod=syntax
set formatoptions-=o
set hidden
set incsearch
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set nobackup
set nofoldenable
set noshowmode
set nowritebackup
set number
set relativenumber
set scrolloff=2
set shiftwidth=0
set sidescrolloff=4
set splitright
set tabstop=4
set title
set undofile
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,Thumbs.db,*.min.js,*.swp,*.exe

if has('win32')
    set path=.\**
else
    set path=$PWD/**
endif

filetype plugin indent on
syntax enable
colorscheme darkblue " Set default colorscheme in case of no plugins

if has('termguicolors')
    set termguicolors
endif

runtime! plugins.vim

function! s:clean_up_whitespaces()
    let cursorpos = getcurpos()
    silent! %s/\_s*\%$//
    silent! %s/\s\+$//
    call setpos('.', cursorpos)
endfunction

augroup custom
    autocmd!
    " Strip out unwanted whitespaces
    autocmd BufWritePre * call s:clean_up_whitespaces()
    " Don't automatically insert comments
    autocmd FileType * set formatoptions-=c formatoptions-=r formatoptions-=o
augroup end

" Custom key mappings
vnoremap <silent> <F9> :sort<CR>
" Use <C-L> to clear the highlighting of :set hlsearch.
nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

if executable('rg')
    set grepprg=rg\ --no-heading\ --vimgrep
    set grepformat=%f:%l:%c:%m
endif

if executable('fd')
    let $FZF_DEFAULT_COMMAND = 'fd --type f'
endif

" <leader>s for Rg search
noremap <leader>s :Rg<space>

" Quickly insert an empty new line without entering insert mode
nnoremap <Leader>o o<Esc>
nnoremap <Leader>O O<Esc>

let g:netrw_list_hide = '\.git/$,\.hg/$,\.svn/$' " Hide VCS directories
