" andrew's vimrc

" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" run :PlugInstall :PlugUpdate

" experiment
set foldmethod=indent
set foldlevel=99

" should the editing content remaining on screen when exited
" set t_ti= t_te=

" set t_Co=256
" set t_AB=^[[48;5;%dm
" set t_AF=^[[38;5;%dm

" termguicolors seems not work very well with tmux
" I know it's a matter of TERM settings, but I have no time to look into it
" set termguicolors
" set term=screen-256color

" common settings
set nocompatible
syntax on
filetype plugin indent on
set ignorecase
set nowrapscan
set hlsearch
set autoindent
set smartindent 
set wrap
set number
set wildmenu
set cursorline
" we now disable tags file discover
" set path+=./**
" set path+=../src
" set path+=../include

" common tab settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" encoding settings
set fileencodings=utf8,cp936
set encoding=utf8

" go to last edit position if possiable
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" cd file dir
" autocmd BufEnter * silent! lcd %:p:h

" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%79v.\+/
autocmd FileType python set colorcolumn=79
autocmd FileType go set colorcolumn=100

" windows settings
if !has("unix") && has("gui_running")
    set guioptions -=m
    set guioptions -=T
    set guifont=Courier_New:h11:cANSI
    set encoding=cp936
elseif has('gui_macvim')
    set guioptions -=m
    set guioptions -=T
    set guioptions -=r
    set guioptions -=R
    set guioptions -=l
    set guioptions -=L
    set guioptions -=b
    set guioptions +=c
    set guifont=Monaco:h12
else
    set t_Co=256
endif

" exiting shortcut
let mapleader=";"
nnoremap qq :q<CR>
" nmap qw :wq<CR>
nnoremap qf :q!<CR>

" split
nnoremap <leader>s :vsplit<CR>

" line movement, like emacs
inoremap <C-E> <ESC>A
inoremap <C-A> <ESC>^i
inoremap <C-B> <LEFT>
inoremap <C-F> <RIGHT>

nnoremap <silent><C-E> <C-E>j
nnoremap <silent><C-Y> <C-Y>k

" map all, use ctrl+k to esc
noremap <C-K> <ESC>
inoremap <C-K> <ESC>
onoremap <C-K> <ESC>
cnoremap <C-K> <ESC>

" avoid tmux key conficts, not used anymore
" nmap <C-[> <C-]>

" path settings
" nmap <F2> :lcd %:p:h<CR>
" nmap <F5> :edit!<CR>

" nmap di :diffthis<CR>

" tab settings
" nmap vs :vsplit<CR>
nnoremap <silent><C-W>n :vnew<CR>
nnoremap <silent><TAB>h :tabprev<CR>
nnoremap <silent><TAB>l :tabnext<CR>
nnoremap <silent><C-N> :tabnew<CR>

" noremap <leader>1 1gt
" noremap <leader>2 2gt
" noremap <leader>3 3gt
" noremap <leader>4 4gt
" noremap <leader>5 5gt
" noremap <leader>6 6gt
" noremap <leader>7 7gt
" noremap <leader>8 8gt
" noremap <leader>9 9gt
" noremap <leader>0 :tablast<cr>

" sql completed settings to eliminate Ctrl-C conflicts
" let g:ftplugin_sql_omni_key='<C-O>'

" python settings
" augroup andrewyi_python_group
    " autocmd!
    " autocmd FileType python setlocal nonu
" augroup END

" backspace settings
" for common
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

autocmd Filetype python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab 
autocmd Filetype javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
autocmd Filetype json setlocal tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
autocmd Filetype go setlocal tabstop=2 softtabstop=0 shiftwidth=2 noexpandtab
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab



""""" plugin settings starts from here

" reference: https://github.com/junegunn/vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
" https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" use :PlugInstall and :PlugClean to install and clean plugins 

call plug#begin('~/.vim/plugged')
Plug 'https://github.com/nvie/vim-flake8'
Plug 'https://github.com/easymotion/vim-easymotion'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/jlanzarotta/bufexplorer'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/flazz/vim-colorschemes'
Plug 'https://github.com/Yggdroot/LeaderF'
Plug 'https://github.com/fatih/vim-go'
Plug 'https://github.com/kien/ctrlp.vim'
Plug 'https://github.com/stephpy/vim-yaml'
call plug#end()
" Plug 'https://github.com/Shougo/denite.nvim'
" Plug 'https://github.com/junegunn/fzf.vim'



" colorsheme settings, origin is: kolor
colorscheme kolor " onedark molokai


" NERDTree settings
" nmap <silent> <F11> :NERDTreeToggle<CR>
nnoremap <silent> <C-H> :NERDTreeToggle<CR>
nnoremap <silent> <F1> :NERDTreeFind<CR>
let NERDTreeIgnore=['\.svn$', '\.git.*$', '\.venv$']
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
" force use '+' '~', comment these out when in macos or linux
let NERDTreeDirArrowExpandable='+'
let NERDTreeDirArrowCollapsible='~'
let NERDTreeNodeDelimiter="\u00a0"


" bufexplorer settings
" nmap <silent><F10> :BufExplorerVerticalSplit<CR>
" nmap <silent><C-J> :BufExplorer<CR> " try leaderf, disable it temporary
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=1        " Split right.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize = 32  " Split width
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerUseCurrentWindow=1  " Open in new window.
let g:bufExplorerDefaultHelp=0       " do not show default help
let g:bufExplorerShowNoName=1        " show no name buffers
" autocmd BufWinEnter \[Buf\ List\] setl nonumber 
let g:bufExplorerDisableDefaultKeyMapping = 1 " disable <leader>bs/v/e ...


" airline settings
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


" fugitive settings
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Glog<CR>


" easymotion settings
" map <Leader> <Plug>(easymotion-prefix)
" noremap not working, don't know why
map <leader>w <Plug>(easymotion-w)
map <leader>b <Plug>(easymotion-b)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>f <Plug>(easymotion-f)
map <leader>F <Plug>(easymotion-F)


" vim flask8 settings
autocmd FileType python map <buffer> <F8> :call Flake8()<CR>
" let g:flake8_quickfix_location="topleft"
"
let g:flake8_show_in_gutter = 1
let g:flake8_error_marker = '->'     " set error marker to 'EE'
let g:flake8_warning_marker = ''     " set warning marker to 'WW'
let g:flake8_pyflake_marker = ''     " disable PyFlakes warnings
let g:flake8_complexity_marker = ''  " disable McCabe complexity warnings
let g:flake8_naming_marker = ''      " disable naming warnings
let g:flake8_show_quickfix=0
" autocmd BufWritePost *.py call Flake8()


" LeaderF
" nmap <C-]> :LeaderfFunction!<CR> " this conflics with tmux settings
nnoremap <leader>[ :LeaderfFunction!<CR>
let g:Lf_ShortcutF = '<C-P>'
let g:Lf_ShortcutB = '<C-J>'
let g:Lf_RootMarkers = ['.git'] " ['.project', '.root', '.svn']
let g:Lf_WorkingDirectoryMode = 'Ac'
" let g:Lf_WindowHeight = 0.30
let g:Lf_CommandMap = {
\ '<C-K>': ['<C-P>'],
\ '<C-J>': ['<C-N>'],
\ '<ESC>': ['<C-K>'],
\ '<C-]>': ['<C-V>']
\}
let g:Lf_HideHelp = 1


" vim-go settings
autocmd FileType go map <buffer> <F8> :GoMetaLinter<CR>
" execute :GoInstallBinaries after installed, also :GoUpdateBinaries
" let g:go_list_type = "quickfix"
" let g:go_def_mode = 'godef'
let g:ctrlp_map = ''
let g:go_highlight_variable_declarations = 0
let g:go_highlight_function_calls = 0
let g:go_highlight_functions = 0
let g:go_highlight_structs = 0
let g:go_highlight_interfaces = 1
let g:go_highlight_operators = 0
let g:go_highlight_string_spellcheck = 0
let g:go_highlight_debug = 0


" tags settings
" nmap <silent> <F8> :!ctags -R --c++-kinds=+px --fields=+iaS --extra=+q --languages=C++,C <CR>
" set tags=./tags;,tags " said this is the correct way from weiyixiao@zhihu
" set tags=./tags;/


" Yggdroot indentLine settings
" let g:indentLine_enabled = 0
" let g:indentLine_char = '┊'
" nmap <leader>ig :IndentLinesToggle<CR>


" taglist settings
" nmap <silent> <F9> :TlistToggle<CR>
" nmap <silent> <C-P> :TlistToggle<CR>
" let Tlist_Show_One_File=1
" let Tlist_Display_Prototype=1
" let Tlist_Exit_OnlyWindow=1
" let Tlist_File_Fold_Auto_Close=1
" let Tlist_Close_On_Select=1


" tagbar settings
"" let g:loaded_tagbar = 1 " disable tagbar because it makes vim run a lot slower
" nmap <silent> <C-P> :TagbarToggle<CR>
" let g:tagbar_left = 1
" let g:tagbar_width = 50
" let g:tagbar_autoclose=1
" let g:tagbar_autofocus = 1
" let g:tagbar_sort = 0
" let g:tagbar_compact = 1


" omni complete settings
" let OmniCpp_NamespaceSearch = 1
" let OmniCpp_GlobalScopeSearch = 1
" let OmniCpp_ShowAccess = 0
"" let OmniCpp_SelectFirstItem = 0
" let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
" let OmniCpp_MayCompleteDot = 0 " no autocomplete after .
" let OmniCpp_MayCompleteArrow = 0 " no autocomplete after ->
" let OmniCpp_MayCompleteScope = 0 " no autocomplete after ::
" let OmniCpp_DefaultNamespaces = ["std"]
" set completeopt=menuone,longest,preview
"" automatically open and close the popup menu / preview window
" au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif


" undo tree settings " need vim 7.3 patch005 ...
" nnoremap <leader>u :UndotreeToggle<cr>


" ctrlp settings
"" let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
" let g:ctrlp_map = '<leader>o'
" nmap <leader>o :CtrlP<CR>
" set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc
" let g:ctrlp_custom_ignore = {
"   \ 'dir':  '\v[\/](\.git|venv)$',
"   \ 'file': '\v\.(pyc|pyo)$',
"   \ 'link': 'some_bad_symbolic_links',
"   \ }
" let g:ctrlp_working_path_mode = 'ra'
" let g:ctrlp_by_filename = 1
" let g:ctrlp_regexp = 1
" let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'
" let g:ctrlp_switch_buffer = 'Et'
" let g:ctrlp_show_hidden = 1


" project settings
" nmap <silent> <F12> <Plug>ToggleProject
" let g:proj_window_width=32
" let g:proj_flags="icgiLmsn"


" syntastic settings
" let g:syntastic_check_on_open=1


" yapf
" vmap <F9> :call yapf#YAPF()<cr>
