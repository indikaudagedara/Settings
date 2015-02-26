call pathogen#infect()
call pathogen#helptags()



" ------------------------------------------
" settings
" ------------------------------------------

syntax on

" open new files in tabs
set switchbuf=useopen,usetab

set ruler
set laststatus=2

" make backspace behave like other apps
set backspace=indent,eol,start

" highlight search
set hlsearch

set number
set smartindent



" ------------------------------------------
" colours
" ------------------------------------------

set t_Co=256

colorscheme molokai
highlight ColorColumn ctermbg=235

"highlight TabLine ctermfg=Blue ctermbg=Yellow
"highlight TabLineFill ctermbg=LightGrey
highlight TabLineSel ctermfg=Red

"highlight MatchParen cterm=underline ctermbg=none
"highlight Search ctermfg=Black



" ------------------------------------------
" key bindings
" ------------------------------------------

" hit enter after search to clear highlight
nnoremap <CR>       :nohlsearch<CR>


noremap <C-N><C-N>  :set invnumber<CR>
noremap <C-L><C-L>  :set invlist<CR>

noremap <leader>si  :set invsmartindent<CR>

" tabs
noremap <leader>tn  :tabnew<CR>
noremap <leader>ts  :tab split<CR>
noremap <leader>e   :tabe
noremap <leader>te  <C-w>gF
noremap <C-Left>    :tabm -1<CR>
noremap <C-Right>   :tabm +1<CR>
noremap <C-Up>      :tabprev<CR>
noremap <C-Down>    :tabnext<CR>

" misc
noremap <leader>w   :w!<CR>
noremap <leader>wq  :wq!<CR>
noremap <leader>q   :q!<CR>
noremap <leader>s   :echo v:servername<CR>
noremap <leader>pp  :setlocal paste<CR>
noremap <leader>np  :setlocal nopaste<CR>
noremap <leader>cc  :set colorcolumn=80<CR>
noremap <leader>ncc :set colorcolumn=0<CR>

noremap <C-j>       5j
noremap <C-k>       5k



" ------------------------------------------
" key bindings for plugins
" ------------------------------------------

" tags
noremap <C-t>       :CtrlPTag<CR>
noremap <leader>r   :CtrlPMRU<CR>

" from NERD tree tabs
noremap NN          :NERDTreeTabsToggle<CR>

noremap <leader>f   :TagbarToggle<CR>



" ------------------------------------------
" autocmds
" ------------------------------------------

" remove trailing whitespace
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()
" all files
"autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()



" ------------------------------------------
" new commands/functions
" ------------------------------------------

" shell command wrapper
" shows command output in same window
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
        let isfirst = 1
        let words = []
        for word in split(a:cmdline)
                if isfirst
                        let isfirst = 0  " don't change first word (shell command)
                else
                if word[0] =~ '\v[%#<]'
                        let word = expand(word)
                endif
                        let word = shellescape(word, 1)
                endif
                call add(words, word)
        endfor
        let expanded_cmdline = join(words)
        let winnr = bufwinnr('^_shell$')
        if ( winnr >= 0 )
                echo winnr
                execute winnr . 'wincmd w'
                execute 'normal ggdG'
        else
                botright new _shell
                resize -15
                setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
                setlocal nonumber
        endif

        call setline(1, '$ ' . expanded_cmdline)
        "call append(line('$'), substitute(getline(1), '.', '=', 'g'))
        silent execute '$read !'. expanded_cmdline

        1
endfunction
