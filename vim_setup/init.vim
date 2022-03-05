let mapleader =","
map <Space> <Nop>
map <Space> <leader>

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

" " Searching
" Plug 'junegunn/fzf', { 'dir': '~/.local/lib/fzf', 'do': './install --all' } " Python
" Plug 'junegunn/fzf.vim'
" Plug 'airblade/vim-rooter'
" Plug 'kien/ctrlp.vim'
" " Plug 'puremourning/vimspector'


" " Speed
" Plug 'unblevable/quick-scope'
" Plug 'tpope/vim-commentary'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-fugitive'
" Plug 'simeji/winresizer'
" Plug 'Raimondi/delimitMate'
" Plug 'preservim/nerdtree'
" Plug 'ludovicchabant/vim-gutentags'
" Plug 'nelstrom/vim-visual-star-search'
" " Plug 'rhysd/clever-f.vim'
" " Plug 'metakirby5/codi.vim'
" Plug 'godlygeek/tabular'
" Plug 'fholgado/minibufexpl.vim'

" " Auto completion
" Plug 'davidhalter/jedi'
" Plug 'neoclide/coc.nvim', {'branch': 'release'} " Npm

" " Latex
" Plug 'SirVer/ultisnips' " Python3
" Plug 'lervag/vimtex' " Latexmk, zathura and texlive-most(AUR)
" Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
" Plug 'matze/vim-tex-fold'
" Plug '907th/vim-auto-save'

" Appearance
Plug 'djoshea/vim-autoread'
Plug 'Yggdroot/indentLine'
Plug 'mhinz/vim-startify'
Plug 'bling/vim-airline'
Plug 'morhetz/gruvbox'
Plug 'junegunn/goyo.vim'

" Plug 'vimwiki/vimwiki'
" Plug 'kovetskiy/sxhkd-vim'
" Plug 'jpalardy/vim-slime'
" Plug 'JuliaEditorSupport/julia-vim'
" Plug 'kassio/neoterm'
call plug#end()


" FUNDAMENTALS

set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus

" Some basics:
set hidden
set noswapfile
set nobackup
set signcolumn=yes

set scrolloff=8
nnoremap c "_c
set nocompatible
filetype plugin on
syntax on
set encoding=utf-8
set number relativenumber

" Enable autocompletion:
set wildmode=longest,list,full

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" which is non-retarded, unlike vim defaults.
set splitbelow splitright

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Replace ex mode with gq
map Q gq

" Check file in shellcheck:
map <leader>s :!clear && shellcheck %<CR>

" Quickly edit/reload this configggguration file
nnoremap <leader>se :e $MYVIMRC<CR>
nnoremap <leader>so :so $MYVIMRC<CR>

" Fast saving and quitting
nmap <leader>w :w!<cr>
nmap <leader>q :qa!<CR>
nmap <leader>x :wqa!<CR>

" Move across wrapped lines like regular lines
"Go to the first non-blank character of a line
noremap 0 ^
"Just in case you need to go to the very beginning of a line
noremap ^ 0

" buffer movement
nmap <leader>l :bn <CR>
nmap <leader>h :bp <CR>

" SMART LINE MOTIONS
" Copy relative line
nnoremap <leader>- :-co.<left><left><left>
nnoremap <leader>_ :+co.<left><left><left>
" Move relative line
nnoremap - :-mo.<left><left><left>
nnoremap _ :+mo.<left><left><left>

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Automatically deletes all trailing whitespace and newlines at end of file on save.
autocmd BufWritePre * %s/\s\+$//e
set splitright

 " Spelling correction when pressing ctrl L
" setlocal spell
" hi SpellBad    ctermfg=none      ctermbg=none     cterm=none      guifg=none   guibg=none gui=none
" set spelllang=en_gb
" inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
 " Spell-check set to <leader>o, 'o' for 'orthography':
" map <leader>O :setlocal spell! spelllang=en_us<CR>


"autocmd BufWritepre * %s/\n\+\%$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
autocmd BufWritePost files,directories !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
" Update binds when sxhkdrc is updated.
autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd


" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Convinient indentation
vnoremap < <gv
vnoremap > >gv

" GRUVBOX
colorscheme gruvbox
