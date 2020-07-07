" Support user-defined $CARGO_HOME directory
if !empty($CARGO_HOME)
    autocmd BufNewFile,BufRead $CARGO_HOME/config,$CARGO_HOME/credentials setf toml
endif
