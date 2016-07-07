" andrew's vimrc, for c++

" common settings
filetype plugin indent on
set ignorecase
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set hlsearch
set wrap
set nu
set nocompatible
set path+=./**
set path+=../src
set path+=../include
set cursorline
" set vb

nmap qq :q<CR>
nmap qw :wq<CR>
nmap qf :q!<CR>
imap <C-\> <Esc>

syntax on
colorscheme kolor
" nmap di :diffthis<CR>
nmap <silent><C-W>n :vnew<CR>
" nmap <silent><C-J> <C-E>j
" nmap <silent><C-K> <C-Y>k
nmap <silent><TAB>h :tabprev<CR>
nmap <silent><TAB>l :tabnext<CR>
nmap <silent> <C-N> :tabnew<CR>
nmap <F7> :lcd %:p:h<CR>
nmap <F5> :edit!<CR>
" go to last edit position if possiable
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" cd file dir
" autocmd BufEnter * silent! lcd %:p:h

" encoding settings
set fileencodings=utf8,cp936
set encoding=utf8
" set encoding=utf8

" project settings
nmap <silent> <F12> <Plug>ToggleProject
let g:proj_window_width=32
let g:proj_flags="icgiLmsn"

" NERDTree settings
nmap <silent> <F11> :NERDTreeToggle<CR>
nmap <silent> <C-H> :NERDTreeToggle<CR>
nmap <silent> <F6> :NERDTreeFind<CR>
let NERDTreeIgnore=['\.svn$', '\.git.*$']
let NERDTreeChDirMode=1
let NERDTreeHighlightCursorline=1
let NERDTreeShowFiles=1
let NERDTreeWinPos="right"
let NERDTreeShowHidden=0
let NERDTreeQuitOnOpen=1
let NERDTreeWinSize=32
let NERDTreeDirArrows=0
let NERDTreeMinimalUI=1
let NERDTreeChDirMode=2

" bufexplorer settings
nmap <silent><F10> :BufExplorerVerticalSplit<CR>
nmap <silent><C-J> :BufExplorer<CR>
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=1        " Split right.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = 32  " Split width
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerUseCurrentWindow=1  " Open in new window.
let g:bufExplorerDefaultHelp=0       " do not show default help
let g:bufExplorerShowNoName=1        " show no name buffers
" autocmd BufWinEnter \[Buf\ List\] setl nonumber 

" syntastic settings
" let g:syntastic_check_on_open=1

" windows settings
if !has("unix")
    if has("gui_running")
        set guioptions -=m
        set guioptions -=T
        set guifont=Courier_New:h11:cANSI
        set encoding=cp936
    endif
else
    set t_Co=256
endif

" tags settings
nmap <silent> <F8> :!ctags -R --c++-kinds=+px --fields=+iaS --extra=+q --languages=C++,C <CR>
set tags=./tags;/

" taglist settings
nmap <silent> <F9> :TlistToggle<CR>
nmap <silent> <C-P> :TlistToggle<CR>
let Tlist_Show_One_File=1
let Tlist_Display_Prototype=1
let Tlist_Exit_OnlyWindow=1
let Tlist_File_Fold_Auto_Close=1
let Tlist_Close_On_Select=1

" omni complete settings
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 0
" let OmniCpp_SelectFirstItem = 0
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 0 " no autocomplete after .
let OmniCpp_MayCompleteArrow = 0 " no autocomplete after ->
let OmniCpp_MayCompleteScope = 0 " no autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std"]
set completeopt=menuone,longest,preview
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

" aireline settings
" let g:airline_detect_modified=1
" let g:airline_detect_paste=1
" let g:airline_left_sep='>'
" let g:airline_right_sep='<'
let g:airline_exclude_filenames = [] " see source for currenat list
let g:airline_detect_whitespace=0
let g:airline#extensions#whitespace#enabled=0
" let g:airline#extensions#tabline#enabled = 1
" let g:airline_section_b=0
set laststatus=2

" sources machine dependent configration
source ~/.vim/p_config/p_vimrc

" python editor
" autocmd FileType python set omnifunc=pythoncomplete#Complete

" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%79v.\+/
set colorcolumn=79

" jedi-vim settings
let g:jedi#use_tabs_not_buffers = 1
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = '2'
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>n"
let g:jedi#completions_command = ""
let g:jedi#rename_command = "<leader>r"
let g:jedi#show_call_signatures = 0 " disable auto complete

" 
runtime bundle/vim-pathogen/autoload/pathogen.vim
