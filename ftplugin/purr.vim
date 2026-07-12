if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

setlocal commentstring=//\ %s
setlocal comments=s1:/*,mb:*,ex:*/,://
setlocal shiftwidth=4 softtabstop=4 expandtab autoindent
setlocal foldmethod=indent

let b:undo_ftplugin = "setlocal commentstring< comments< shiftwidth< softtabstop< expandtab< autoindent< foldmethod<"
