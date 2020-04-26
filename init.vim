let mapleader = "\<Space>"
set incsearch
set list
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
set noshowmode
set number
set relativenumber
set runtimepath^=/usr/share/vim/vimfiles/
set scrolloff=2
set shiftwidth=0
set sidescrolloff=4
set splitright
set tabstop=4
set undofile
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,Thumbs.db,*.min.js,*.swp,*.exe

filetype plugin on
syntax enable

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
    " Keybindings to quickly run the buffer being edited
    autocmd FileType python nnoremap <buffer> <F8> :w<CR>:exec '!python' shellescape(@%, 1)<CR>
augroup end

" Custom key mappings
vnoremap <F9> :sort<CR>
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
