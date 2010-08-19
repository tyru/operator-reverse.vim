" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('g:loaded_operator_reverse') && g:loaded_operator_reverse
    finish
endif
let g:loaded_operator_reverse = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


if !exists('g:operator_reverse_no_default_keymappings')
    let g:operator_reverse_no_default_keymappings = 0
endif



" http://vim.wikia.com/wiki/Reverse_all_lines
command!
\   -bar -range=%
\   OperatorReverseLines
\   <line1>,<line2>g/^/m<line1>-1


call operator#user#define_ex_command('reverse-lines', 'OperatorReverseLines')
call operator#user#define('reverse-text', 'operator#reverse#reverse_text')


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
