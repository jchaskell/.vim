" Last updated 9 June 2026
" Heavily borrowed from https://dougblack.io/words/a-good-vimrc.html and
" jessfraz

set nocompatible

" ============================================================
"  Plugins — managed by vim-plug (https://github.com/junegunn/vim-plug)
"  Install/update:  :PlugInstall   :PlugUpdate   :PlugClean
" ============================================================

" Auto-bootstrap on a fresh clone: fetch vim-plug if it's missing, then install
" any declared-but-not-yet-installed plugins on first launch.
let s:plug_file = expand('~/.vim/autoload/plug.vim')
if empty(glob(s:plug_file))
  silent execute '!curl -fLo ' . s:plug_file . ' --create-dirs '
        \ . 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

call plug#begin('~/.vim/plugged')

" --- migrated from the old pathogen bundle ---
Plug 'ctrlpvim/ctrlp.vim'
Plug 'Raimondi/delimitMate'
Plug 'Yggdroot/indentLine'
Plug 'preservim/nerdtree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ap/vim-buftabline'
Plug 'airblade/vim-gitgutter'
Plug 'preservim/vim-markdown'
Plug 'heavenshell/vim-pydocstring'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'tpope/vim-surround'
Plug 'stephpy/vim-yaml'
Plug 'mg979/vim-visual-multi'

" --- new ---
Plug '/opt/homebrew/opt/fzf'   " use the brew-installed fzf binary/runtime
Plug 'junegunn/fzf.vim'        " :Files, :Buffers, :Rg, etc.
Plug 'tpope/vim-fugitive'      " Git inside vim
Plug 'jpalardy/vim-slime'      " send code to a REPL

call plug#end()
" plug#end() runs `filetype plugin indent on` and `syntax on` automatically.

" If any declared plugin isn't installed yet (e.g. a fresh clone), install them
" once on startup, then reload the config so they're active immediately.
autocmd VimEnter *
      \ if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \ |   PlugInstall --sync | source $MYVIMRC
      \ | endif

" Bind Esc to jj
inoremap jj <Esc>
let mapleader=","

" Color scheme
syntax on

" True color (24-bit). Must be set before :colorscheme.
if has('termguicolors')
  " Make true color work inside tmux/screen
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

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

" Shortcuts to edit and source vimrc
nnoremap <leader>ev :vsp $MYVIMRC<CR>
nnoremap <leader>sv :source $MYVIMRC<CR>

" \n jots a vim pain point (see ~/.vim/vim-pain.md). Append a timestamped entry
" and drop into insert at the bottom so you can capture the annoyance in one move.
nnoremap <leader>n :split ~/.vim/vim-pain.md<CR>:call append(line('$'), '- ' . strftime('%Y-%m-%d') . ': ')<CR>G$a

" \? opens the vim setup/cheatsheet in a new tab (~/.vim/vim-setup.md)
nnoremap <leader>? :tabedit ~/.vim/vim-setup.md<CR>

" --- Getting help / answering your own vim questions ---
" \H fuzzy-searches all vim help tags (fzf); \M searches your own mappings.
nnoremap <leader>H :Helptags<CR>
nnoremap <leader>M :Maps<CR>

" Ask Claude Code a question without leaving vim. The answer streams into a
" terminal split (non-blocking). Usage:  :Ask how do I move between tabs
" \c prefills the command line so you just type the question and hit Enter.
function! AskClaude(question) abort
  botright 15new
  call term_start(['claude', '-p',
        \ 'Answer concisely for a vim user. ' . a:question],
        \ {'curwin': 1, 'term_name': 'ask-claude'})
endfunction
command! -nargs=+ Ask call AskClaude(<q-args>)
nnoremap <leader>c :Ask<Space>

" re open previously open file
nnoremap <leader><leader> :e#<CR>

" w!! lets you save a file as sudo when you forgot to open it with sudo
cmap w!! w !sudo tee % >/dev/null

" run visually selected code in python with ,p
nnoremap <leader>p :w !python<CR>
nnoremap <leader>r :w !R<CR>

" remove search highlight
nnoremap <leader><space> :noh<CR>

" 80 character line limit
if exists('+colorcolumn')
  set colorcolumn=80
else
  au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Other shortcuts
" \s saves session; reopen with vim -S
nnoremap <leader>s :mksession<CR>

" Use ripgrep for :grep and CtrlP (falls back gracefully if rg is absent)
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

" --- fzf.vim: fuzzy file/buffer/grep finder ---
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
" \a ripgreps the project; \A seeds it with the word under the cursor
nnoremap <leader>a :Rg<CR>
nnoremap <leader>A :Rg <C-r><C-w><CR>

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

" vim-fugitive: Git inside vim
nnoremap <leader>gs :Git<CR>
nnoremap <leader>gb :Git blame<CR>
nnoremap <leader>gd :Gdiffsplit<CR>

" vim-slime: send code to a REPL.
" Default target is a :terminal buffer (works without tmux). If you're working
" inside tmux, set g:slime_target = "tmux" instead and it'll send to a pane.
let g:slime_target = "vimterminal"
let g:slime_bracketed_paste = 1
" C-c C-c sends the current paragraph/selection to the REPL (slime default).
