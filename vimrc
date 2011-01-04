let g:snips_author='Matt Enright'
let g:snips_author_mail='awickedshimmy@gmail.com'

command! -bar -nargs=1 OpenURL :!gnome-open <args>

set ruler
set number
set laststatus=2
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)[%{&fo}]\ %P
set bg=dark
set hidden
set nowrap

set incsearch
:nnoremap <CR> :nohlsearch<CR>/<BS>
set ignorecase
set smartcase

set tabstop=4
set shiftwidth=4
set autoindent
set copyindent
set preserveindent

filetype on
filetype plugin on
filetype indent on
nmap ,a :GNOMEAlignArguments<CR>

set wrapmargin=120
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

nnoremap <F3> :Gblame<CR>
nnoremap <F5> :make<CR>

set tags=tags
let g:ctags_statusline=1
let generate_tags=1
let Tlist_Compact_Format=1
let Tlist_Exit_OnlyWindow=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_File_Fold_Auto_Close=1
nnoremap <F4> :TlistToggle<CR><C-W>=

map ,v :sp ~/.vimrc<CR><C-W>_
map <silent> ,V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

inoremap <Left>  <NOP>
inoremap <Right> <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>

set completeopt=menu,menuone,longest

" Make sure coding conventions are not violated for particular cases
" (thanks to Jeff King <peff@peff.net> for the tip via git@vger.kernel.org)
au BufNewFile,BufRead ~/workspace/git/* set noet sts=8 sw=8 ts=8

" Remove trailing whitespace (k0001, #git)
" autocmd BufWritePre *:%s/\s\+$//e

" Thanks to Loïc Minier <lool@dooz.org>, desktop-devel-list for the
" whitespace indicators; addditions from Bastien Nocera <hadess@hadess.net>,
" via Xavier Claessens <xclaesse@gmail.com>
set list
set listchars=tab:↦\ ,trail:»,extends:↷,precedes:↶,nbsp:% ",eol:•

colorscheme vividchalk
if has('gui_running')
    set cursorline
    set guioptions=aeic
    colorscheme candycode
    set guifont=Deja\ Vu\ Sans\ Mono\ 7.5
endif

let g:Tex_DefaultTargetFormat="pdf"
let g:Tex_ViewRule_pdf="gnome-open"
let g:Tex_VeiwRule_dvi="gnome-open"

au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

" Load local .{vim,ex}rc files from the current directory
set exrc
set secure
