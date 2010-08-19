" vim:foldmethod=marker:fen:
scriptencoding utf-8

" Load Once {{{
if exists('s:loaded') && s:loaded
    finish
endif
let s:loaded = 1
" }}}
" Saving 'cpoptions' {{{
let s:save_cpo = &cpo
set cpo&vim
" }}}


function! s:select(motion_wiseness) "{{{
    " From http://gist.github.com/356290
    " But specialized to operator-user.

    try
        " For saving &selection. See :help :map-operator
        let sel_save = &l:selection
        let &l:selection = "inclusive"
        " Save @@.
        let reg_save     = getreg('z', 1)
        let regtype_save = getregtype('z')

        if a:motion_wiseness == 'char'
            let ex = '`[v`]'
        elseif a:motion_wiseness == 'line'
            let ex = '`[V`]'
        elseif a:motion_wiseness == 'block'
            let ex = "`[\<C-v>`]"
        else
            " silent execute 'normal! `<' . a:motion_wiseness . '`>'
            echoerr 'internal error, sorry: this block never be reached'
        endif
    finally
        let &l:selection = sel_save
        call setreg('z', reg_save, regtype_save)
    endtry

    execute 'silent normal!' ex
endfunction "}}}
function! s:operate_on_word(funcname, motion_wiseness) "{{{
    " Select previously-selected range in visual mode.
    call s:select(a:motion_wiseness)

    let reg_z_save     = getreg('z', 1)
    let regtype_z_save = getregtype('z')

    try
        " Filter selected range with `{a:funcname}(selected_text)`.
        let cut_with_reg_z = '"zc'
        execute printf("normal! %s\<C-r>=%s(@z)\<CR>", cut_with_reg_z, a:funcname)
    finally
        call setreg('z', reg_z_save, regtype_z_save)
    endtry
endfunction "}}}


" operator-reverse
function! operator#reverse#reverse_text(motion_wiseness) "{{{
    call s:operate_on_word('s:reverse_word', a:motion_wiseness)
endfunction "}}}
function! s:reverse_word(word) "{{{
    return join(reverse(split(a:word, '\zs')), '')
endfunction "}}}


" Restore 'cpoptions' {{{
let &cpo = s:save_cpo
" }}}
