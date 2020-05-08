augroup disable_last_position_jump
    autocmd!
    autocmd BufWinEnter <buffer> execute 'normal! gg0'
augroup end
