" Last updated 23 February 2019
" Heavily borrowed from https://dougblack.io/words/a-good-vimrc.html and
" jessfraz

" Load plugins
execute pathogen#infect()
call pathogen#helptags()

set nocompatible
filetype off
filetype plugin indent on

" Bind Esc to jj
imap jj <Esc>
let mapleader=","

" Color scheme
syntax on
colorscheme monokai

" Python highlighting
let python_highlight_all=1

" Settings
set noerrorbells
set number          " show line numbers
set showcmd         " shows last command
set showmode        " show current mode

set noswapfile      " don't use swapfiles
set nobackup        " don't use backups
set nowritebackup
set splitbelow      " split horizontal windows below
set splitright      " split vertical windows right
set encoding=utf-8
set autowrite
set autoread
set laststatus=2
set hidden
set ruler

set noshowmatch     " do not show matching brackets by flickering
set noshowmode      " use airline to show mode
set incsearch       " shows matching while typing
set hlsearch        " highlight found searches
set ignorecase      " make search case insensitive
set smartcase       " except when search includes upper case
set lazyredraw

" syntax highlighting
set nocursorcolumn
set nocursorline
syntax sync minlines=256
set synmaxcol=300
set re=1

set backspace=indent,eol,start
set history=100

" handle long lines nicely
set wrap
set textwidth=79
set formatoptions=qrn1

set autoindent
set complete-=i
set showmatch
set smarttab
set et
set tabstop=4
set shiftwidth=4
set expandtab

" Time out on key codes but not mappings
set notimeout
set ttimeout
set ttimeoutlen=10

" Completion
set complete=.,w,b,u,t

set scrolloff=1
set sidescrolloff=5

" Persistent edit history
set undodir=~/.vim/undodir
set undofile

" Mouse
if has('mouse')
  set mouse=a
endif

" Universal clipboard
set clipboard=unnamed

" Movement
" if lines are wrapped, don't skip over wrapped line 
" map j gj
" map k gDTreeShowHidden=1

" use gundo for undo - shortcut is \u
nnoremap <leader>u :GundoToggle<CR>

" Shortcuts to edit and source vimrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" re open previously open file
nnoremap <leader><leader> :e#<CR>

" w!nnoremap !ettings                       "
" " ----------------------------------------- "lets you change to sudo if you need to
cmap w!! w !sudo tee % >/dev/null

" run visually selected code in python with ,p
nnoremap <leader>p :w !python<CR>
nnoremap <leader>r :w !R<CR>

" remove search highlight
nnoremap <leader><space> :noh

" 80 character line limit
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Other shortcuts
nnoremap <leader>s :mksession<CR> " \s saves session; reopen with vim -S

" Ag shortcut 
nnoremap <leader>a :Ag

" Ctags for R
let g:tagbar_type_r = {
    \ 'ctagstype' : 'r',
    \ 'kinds'     : [
        \ 'f:Functions',
        \ 'g:GlobalVariables',
        \ 'v:FunctionVariables',
    \ ]
\ }

" allows cursor change in tmux mode
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" " Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                    \ | wincmd p | diffthis
endif

" ----------------------------------------- "
"  File Type settings                         "
"  ----------------------------------------- "
au BufNewFile,BufRead *.vim setlocal noet ts=4 sw=4 sts=4
au BufNewFile,BufRead *.txt setlocal noet ts=4 sw=4
au BufNewFile,BufRead *.md setlocal spell noet ts=4 sw=4
    \ set textwidth=0
    \ set wrap linebreak nolist
au BufNewFile,BufRead *.yml,*.yaml setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.cpp setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.hpp setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.json setlocal expandtab ts=2 sw=2
au BufNewFile,BufRead *.jade setlocal expandtab ts=2 sw=2
augroup filetypedetect
  au BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
  au BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
augroup END

au FileType nginx setlocal noet ts=4 sw=4 sts=4

" Go settings
au BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4

" scala settings
autocmd BufNewFile,BufReadPost *.scala setl shiftwidth=2 expandtab

" Markdown Settings
autocmd BufNewFile,BufReadPost *.md setl ts=4 sw=4 sts=4 expandtab

" lua settings
autocmd BufNewFile,BufRead *.lua setlocal noet ts=4 sw=4 sts=4

" Dockerfile settings
autocmd FileType dockerfile set noexpandtab

" shell/config/systemd settings
autocmd FileType fstab,systemd set noexpandtab
autocmd FileType gitconfig,sh,toml set noexpandtab

" python indent
autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80 smarttab expandtab

" R indent
autocmd BufNewFile,BufRead *.R setlocal tabstop=2 softtabstop=2 shiftwidth=2 textwidth=80 smarttab expandtab

" toml settings
au BufRead,BufNewFile MAINTAINERS set ft=toml

" hcl settings
au BufRead,BufNewFile *.workflow set ft=hcl

" mips settings
au BufRead,BufNewFile *.mips set ft=mips

" spell check for git commits
autocmd FileType gitcommit setlocal spell

" Wildmenu completion {{{
set wildmenu
set wildmode=list:full

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg   " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX bullshit
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=go/pkg                           " Go static files
set wildignore+=go/bin                           " Go bin files
set wildignore+=go/bin-vagrant                   " Go bin-vagrant files
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files

" Airline theme
let g:airline_theme='badwolf'
let g:airline_section_x = '%{PencilMode()}'

" delimitMate
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_smart_quotes = 1
let g:delimitMate_expand_inside_quotes = 0
let g:delimitMate_smart_matchpairs = '^\%(\w\|\$\)'

" NERDTree
let NERDTreeShowHidden=1

let NERDTreeIgnore=['\.vim$', '\~$', '\.git$', '.DS_Store']

" Close nerdtree and vim on close file
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Completion
let g:deoplete#enable_at_startup = 1
let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources._ = ['buffer', 'member', 'tag', 'file', 'neosnippet']
let g:deoplete#sources#go#sort_class = ['func', 'type', 'var', 'const']
let g:deoplete#sources#go#align_class = 1

" vim-markdown
" disable folding
let g:vim_markdown_folding_disabled = 1

" Allow for the TOC window to auto-fit when it's possible for it to shrink.
" It never increases its default size (half screen), it only shrinks.
let g:vim_markdown_toc_autofit = 1

" Disable conceal
let g:vim_markdown_conceal = 0

" Allow the ge command to follow named anchors in links of the form
" file#anchor or just #anchor, where file may omit the .md extension as usual
let g:vim_markdown_follow_anchor = 1

" highlight frontmatter
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1

" YouCompleteMe
let g:ycm_autoclose_preview_window_after_completion=1
map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
