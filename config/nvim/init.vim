
call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))

Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
Plug 'KeitaNakamura/neodark.vim'

"Plug 'Yggdroot/indentLine'
call plug#end()


colorscheme neodark

" Tex Conceal Plug-in
set conceallevel=2
let g:tex_conceal='abdmg'
hi Conceal ctermbg=none
let g:tex_superscripts= "[0-9a-zA-W.,:;+-<>/()=]"
let g:tex_subscripts= "[0-9aehijklmnoprstuvx,+-/().]"
let g:tex_conceal_frac=1
