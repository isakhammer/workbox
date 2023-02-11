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

" Searching
Plug 'junegunn/fzf', { 'dir': '~/.local/lib/fzf', 'do': './install --all' } " Python
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'
Plug 'kien/ctrlp.vim'

" Speed
Plug 'unblevable/quick-scope'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'simeji/winresizer'
Plug 'Raimondi/delimitMate'
Plug 'preservim/nerdtree'
Plug 'nelstrom/vim-visual-star-search'
Plug 'godlygeek/tabular'
Plug 'fholgado/minibufexpl.vim'

" Auto completion
Plug 'davidhalter/jedi'
" Plug 'neoclide/coc.nvim', {'branch': 'release'} " Npm

" Workflow
Plug 'jpalardy/vim-slime'
Plug 'mroavi/vim-julia-cell', { 'for': 'julia' }

" Latex
Plug 'SirVer/ultisnips' " Python3
Plug 'lervag/vimtex' " Latexmk, zathura and texlive-most(AUR)
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
" Plug 'matze/vim-tex-fold'
Plug '907th/vim-auto-save'

" Appearance
Plug 'djoshea/vim-autoread'
Plug 'mhinz/vim-startify'
Plug 'bling/vim-airline'
Plug 'junegunn/goyo.vim'
Plug 'kovetskiy/sxhkd-vim'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'kassio/neoterm'

" colorschemes
Plug 'morhetz/gruvbox'
Plug 'KeitaNakamura/neodark.vim'


Plug 'ron89/thesaurus_query.vim'

call plug#end()


"""""""
" GRUVBOX
"""""""
" colorscheme gruvbox
" coc debug information
" let g:gruvbox_guisp_fallback = 'bg'

" set termguicolors                " recommended
colorscheme neodark

"""""""""""""""
"THESAURUS_QUERY
""""""""""""""""
nnoremap <Leader>d :ThesaurusQueryReplaceCurrentWord<CR>
vnoremap <Leader>d y:ThesaurusQueryReplace <C-r>"<CR>


"""""""
" IDENTATION
"""""""
set expandtab           " enter spaces when tab is pressed
set textwidth=250       " break lines when line length increases
set tabstop=4           " use 4 spaces to represent tab
set softtabstop=4
set shiftwidth=4        " number of spaces to use for auto indent
set colorcolumn=80      " color for column after 80 tegn
set smartindent         " copy indent from current line when starting a new line
set autochdir           " Automatically change workdir to current file

"""""""
" BASICS
"""""""
set bg=dark
"set bg=light
" set thesaurus+=~/workbox/config/nvim/thesaurus.txt

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

" Quickly edit/reload this configuration file
let $MYVIMRC_PERSONAL = "~/workbox/config/nvim/init.vim"
let $CODE_DIR = "~/code/"
nnoremap <leader>se :e $MYVIMRC_PERSONAL<CR>
nnoremap <leader>so :so $MYVIMRC<CR>

" Fast saving and quitting
nmap <leader>w :w!<CR>
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
" nnoremap <leader>- :-co.<left><left><left>
" nnoremap <leader>_ :+co.<left><left><left>
" Move relative line
" nnoremap - :-mo.<left><left><left>
" nnoremap _ :+mo.<left><left><left>

" Save file as sudo on files that require root permission
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Automatically deletes all trailing whitespace and newlines at end of file on save.
autocmd BufWritePre * %s/\s\+$//e
set splitright

 " Spelling correction when pressing ctrl L
" setlocal spell
set spell
set spellfile+=~/workbox/config/nvim/spell/en.utf-8.add

" hi SpellBad    ctermfg=none      ctermbg=none     cterm=none      guifg=none   guibg=none gui=none
" hi clear SpellBad
" hi SpellBad cterm=underline

set spelllang=en
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u

 " Spell-check set to <leader>o, 'o' for 'orthography':
"map <leader>O :setlocal spell! spelllang=en_us<CR>


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


"""""""
" GOYO:
"""""""
" Goyo plugin makes text more readable when writing prose:
map <leader>y :Goyo


"""""""
" NERD TREE:
"""""""
map <leader>n :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
if has('nvim')
	let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
else
	let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
endif

"""""""
" CTRL P
"""""""
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_map  = '<c-g>'
map <leader>b <Esc><Esc>:CtrlPBuffer <cr>
map <leader>m <Esc><Esc>:CtrlPMRU <cr>
let g:ctrlp_prompt_mappings = {
    \ 'PrtSelectMove("j")':   ['<c-j>', '<c-n>'],
    \ 'PrtSelectMove("k")':   ['<c-k>', '<c-p>'],
    \ 'PrtHistory(-1)':       ['<down>'],
    \ 'PrtHistory(1)':        ['<up>'],
    \ }

"""""""""""""""""
"  FZF- finder
"""""""""""""""""
map <leader>F <Esc><Esc>:Files!<cr>
map <leader>G <Esc><Esc>:Rg <cr>

let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

"""""""""""""""""
"  Vim-root
"""""""""""""""""
let g:rooter_patterns = ['.git']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""" LATEX SETUP """""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:tex_comment_nospell=1

""""""""""""""""""""""""""""""
" => vim-autosave plugin
""""""""""""""""""""""""""""""

function EnableAutoSave()
  autocmd TextChanged,TextChangedI * silent write
endfunction

" Autosave for tex
au BufRead,BufNewFile *.tex :call EnableAutoSave()

""""""""""""""""""""""""""""""
" => Vimtex Plugin
" Check :h vimtex-requirements for more
""""""""""""""""""""""""""""""
let maplocalleader = "\\"
let g:Tex_DefaultTargetFormat='pdf'
let g:vimtex_view_enabled=1
let g:vimtex_view_automatic=1
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0

" main.tex system -> https://github.com/lervag/vimtex/issues/155
au FileType tex let b:main_tex_file='main.tex'


" Clean directory of generated files
nnoremap <localleader>lc :VimtexStop<cr>:VimtexClean<cr>
nnoremap <localleader>lca :VimtexStop<cr>:VimtexClean!<cr>

augroup vimtex_config
  au!
  au User VimtexEventQuit call vimtex#compiler#clean(0)
augroup END

let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0

" Start client server for backward search from pdf to vim
if empty(v:servername) && exists('*remote_startserver')
  call remote_startserver('VIM')
endif

let g:vimtex_syntax_enabled=0



""""""""""""""""""""""""""""""
" => Tex Conceal Plug-in
"
"""""""""""""""""""""""""""""""
set conceallevel=2
let g:tex_conceal='abdmg'
hi Conceal ctermbg=none
let g:tex_superscripts= "[0-9a-zA-W.,:;+-<>/()=]"
let g:tex_subscripts= "[0-9aehijklmnoprstuvx,+-/().]"
let g:tex_conceal_frac=1

""""""""""""""""""""""""""""""
" => Ulti Snips Plugin
"""""""""""""""""""""""""""""""
let g:UltiSnipsExpandTrigger='<c-space>'
let g:UltiSnipsJumpForwardTrigger='<c-space>'
let g:UltiSnipsJumpBackwardTrigger='<c-z>'
" let g:UltiSnipsEditSplit="vertical"
" let g:UltiSnipsEditSplit="horizontal"
let g:UltiSnipsEditSplit="context"
nnoremap <leader>e :UltiSnipsEdit<CR>
let g:UltiSnipsSnippetsDir="~/workbox/config/nvim/UltiSnips"
let g:UltiSnipsSnippetDirectories=['~/workbox/config/nvim/UltiSnips']


""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""
" Autopair:
""""""
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<M-b>'


"""""""
" Coc:
""""""
" doesnt work with tab :(
" source ~/workbox/config/nvim/cocrc.vim
" hi CocInfoFloat guifg=#hex-color guibg=#hex-color
" hi CocWarningFloat guifg=#hex-color guibg=#hex-color
" hi CocHintFloat guifg=#hex-color guibg=#hex-color
" nmap <silent> gd <Plug>(coc-definition)


"""""
" AIRLINE
"""""
" call airline#parts#define_function('coc_status', 'coc#status')
" let g:airline_section_y = airline#section#create_right(['coc_status','ffenc'])

""""
" JULIA VIM
""""
" turn off tabs to avoid collision with coc-vim and instead convert automatically.
let g:latex_to_unicode_tab = 1
" let g:latex_to_unicode_auto = 0

" if &filetype ==# 'julia'
"     let g:latex_to_unicode_tab = 1
" endif

" inoremap <C-B> <C-X><C-U>

