call pathogen#infect()
call pathogen#helptags()

syntax on


set switchbuf=newtab,usetab

" make backspace behave like other apps
set backspace=indent,eol,start

noremap <C-M><C-M> :set invnumber<CR>
noremap <C-L><C-L> :set invlist<CR>
noremap <C-I><C-I> :set invsmartindent<CR>
noremap <C-Right>  :tabnext<CR>
noremap <C-left>   :tabprev<CR>
noremap <C-x>      :q<CR>
noremap <C-t>      :CtrlPTag<CR>

" from NERD tree tabs
noremap NN         :NERDTreeTabsToggle<CR>

noremap <leader>t :tabnew<CR>
noremap <leader>e :tabe
noremap <C-Up> :tabm -1<CR>
noremap <C-Down> :tabm +1<CR>

map <F8> :TagbarToggle<CR>
