" andrew's vimrc

" build vim from source codes on ubuntu 18.04 with v8.2.0000
" apt install libncurses5-dev libncursesw5-dev
" rm src/auto/config.cache || make distclean
" ./configure \
"     --enable-fail-if-missing \
"     --disable-darwin \
"     --disable-smack \
"     --disable-selinux \
"     --enable-pythoninterp \
"     --enable-python3interp \
"     --enable-cscope \
"     --enable-terminal \
"     --enable-multibyte \
"     --disable-rightleft \
"     --disable-arabic \
"     --disable-gui \
"     --disable-icon-cache-update \
"     --disable-desktop-database-update \
"     --disable-gpm \
"     --disable-sysmouse \
"     --with-features=huge
" #    --enable-luainterp
" make && make install

" experiment
set foldmethod=indent
set foldlevel=99

" common settings
set nocompatible
syntax on
filetype plugin indent on
set ignorecase
set nowrapscan
set wrap
set hlsearch
set autoindent
set smartindent 
set number
set wildmenu
set cursorline

" common tab settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

" encoding
set fileencodings=utf8,cp936
set encoding=utf8

" go to last edit position if possiable
" this could be found in $VIMRUNTIME/defaults.vim
augroup last-edit-place
    autocmd!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
      \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
      \ |   exe "normal! g`\""
      \ | endif
augroup end

" os/vim/gvim settings
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
nnoremap <unique> qq :q<CR>
nnoremap <unique> qf :q!<CR>

" global leader
let mapleader=";"

" line movement, like emacs
inoremap <unique> <C-E> <ESC>A
inoremap <unique> <C-A> <ESC>^i
inoremap <unique> <C-B> <LEFT>
inoremap <unique> <C-F> <RIGHT>

nnoremap <unique> <silent> <C-E> <C-E>j
nnoremap <unique> <silent> <C-Y> <C-Y>k

" use ctrl+k as esc when insert
inoremap <unique> <C-K> <ESC>

" tab settings
nnoremap <unique> <silent> <C-W>s :vsplit<CR>
nnoremap <unique> <silent> <C-W>n :vnew<CR>
nnoremap <unique> <silent> <TAB>h :tabprev<CR>
nnoremap <unique> <silent> <TAB>l :tabnext<CR>
nnoremap <unique> <silent> <C-N> :tabnew<CR>
nnoremap <unique> <silent> <C-W>t <C-W>T

" sql completed settings to eliminate Ctrl-C conflicts
" let g:ftplugin_sql_omni_key='<C-O>'

augroup andrew-python
    autocmd!
    autocmd Filetype python setlocal
                \ tabstop=4 softtabstop=4 shiftwidth=4 expandtab 
	autocmd FileType python set colorcolumn=79
augroup end

augroup andrew-go
    autocmd!
    autocmd Filetype go setlocal
                \ tabstop=2 softtabstop=0 shiftwidth=2 noexpandtab
	autocmd FileType go set colorcolumn=100
augroup end

augroup andrew-javascript
    autocmd!
    autocmd Filetype javascript setlocal
                \ tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
augroup end

augroup andrew-json
    autocmd!
    autocmd Filetype json setlocal
                \ tabstop=2 softtabstop=2 shiftwidth=2 noexpandtab
augroup end

augroup andrew-yaml
    autocmd!
    autocmd BufNewFile,BufReadPost *.{yaml,yml} set
                \ filetype=yaml foldmethod=indent
    autocmd FileType yaml setlocal
                \ tabstop=2 softtabstop=2 shiftwidth=2 expandtab
augroup end

" tags settings
" set tags=./tags;,tags



" plugin settings starts from here
" TODO: some plugins and outof fansion, please update

" reference: https://github.com/junegunn/vim-plug
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" useful commands:
" :PlugInstall :PlugUpdate :PlugClean to install/update/clean plugins
" :PlugUpgrade update vim-plug itself
" :PlugStatus :PlugDiff ...

call plug#begin('~/.vim/plugged')
Plug 'https://github.com/easymotion/vim-easymotion'
Plug 'https://github.com/tpope/vim-fugitive'
Plug 'https://github.com/vim-airline/vim-airline'
Plug 'https://github.com/flazz/vim-colorschemes'
Plug 'https://github.com/nvie/vim-flake8'
Plug 'https://github.com/fatih/vim-go'
Plug 'https://github.com/stephpy/vim-yaml'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/jlanzarotta/bufexplorer'
" Plug 'https://github.com/Yggdroot/LeaderF'
" Plug 'https://github.com/Shougo/denite.nvim'
call plug#end()

" easymotion settings
" map <Leader> <Plug>(easymotion-prefix)
" noremap not working, don't know why
map <leader>w <Plug>(easymotion-w)
map <leader>b <Plug>(easymotion-b)
map <leader>j <Plug>(easymotion-j)
map <leader>k <Plug>(easymotion-k)
map <leader>f <Plug>(easymotion-f)
map <leader>F <Plug>(easymotion-F)

" fugitive settings
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gl :Glog<CR>

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

" colorsheme settings, origin is: kolor
colorscheme kolor " onedark molokai

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

" vim-go settings
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

" NERDTree settings
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
let g:bufExplorerDisableDefaultKeyMapping = 1 " disable <leader>bs/v/e ...

" LeaderF
"" nmap <C-]> :LeaderfFunction!<CR> " this conflics with tmux settings
" nnoremap <leader>[ :LeaderfFunction!<CR>
" let g:Lf_ShortcutF = '<C-P>'
" let g:Lf_ShortcutB = '<C-J>'
" let g:Lf_RootMarkers = ['.git'] " ['.project', '.root', '.svn']
" let g:Lf_WorkingDirectoryMode = 'Ac'
"" let g:Lf_WindowHeight = 0.30
" let g:Lf_CommandMap = {
" \ '<C-K>': ['<C-P>'],
" \ '<C-J>': ['<C-N>'],
" \ '<ESC>': ['<C-K>'],
" \ '<C-]>': ['<C-V>']
" \}
" let g:Lf_HideHelp = 1
