call pathogen#infect()
call pathogen#helptags()

syntax on

" open new files in tabs
set switchbuf=useopen,usetab

set ruler
set laststatus=2

" make backspace behave like other apps
set backspace=indent,eol,start

" highlight search
set hlsearch

" hit enter after search to clear highlight
nnoremap <CR>      :nohlsearch<CR>

set number
noremap <C-N><C-N> :set invnumber<CR>
noremap <C-L><C-L> :set invlist<CR>

set smartindent
noremap <C-I><C-I> :set invsmartindent<CR>

"~/.user_profile

" tabs
noremap <leader>tn :tabnew<CR>
noremap <leader>e  :tabe
noremap <leader>te <C-w>gF
noremap <C-Left>   :tabm -1<CR>
noremap <C-Right>  :tabm +1<CR>
noremap <C-Up>     :tabnext<CR>
noremap <C-Down>   :tabprev<CR>

" misc
noremap <leader>w  :w!<CR>
noremap <leader>wq :wq!<CR>
noremap <leader>q  :q!<CR>
noremap <leader>s  :echo v:servername<CR>
noremap <leader>pp :setlocal paste<CR>i
noremap <leader>np :setlocal nopaste<CR>

noremap <C-j>      5j
noremap <C-k>      5k

" ------------------------------------------
" from plugins
" ------------------------------------------

" tags
noremap <C-t>      :CtrlPTag<CR>
noremap <leader>r  :CtrlPMRU<CR>

" from NERD tree tabs
noremap NN         :NERDTreeTabsToggle<CR>

noremap <leader>f  :TagbarToggle<CR>


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
