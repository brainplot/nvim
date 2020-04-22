" vi: set ts=4 sw=4 expandtab:

let g:lightline = {
            \ 'colorscheme': 'one',
            \ 'active': {
            \   'left': [ [ 'mode', 'paste' ],
            \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
            \ },
            \ 'component_function': {
            \   'cocstatus': 'coc#status',
            \   'gitbranch': 'gitbranch#name'
            \ },
            \ }

augroup lightline
    autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()
augroup end
