let g:snips_author = 'Matt Enright'
let g:snips_author_mail = 'awickedshimmy@gmail.com'

set ruler
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
set bg=dark

set autoindent

set incsearch
set ignorecase
set smartcase

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

set wrapmargin=120
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

set tags=tags
let g:ctags_statusline = 1
let generate_tags = 1
let Tlist_Compact_Format = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fold_Auto_Close = 1
nnoremap TT :TlistToggle<CR>
nnoremap <F4> :TlistToggle<CR>

nmap <silent> <C-v> :set paste<CR>"*p:set nopaste<CR>

set dictionary+=/usr/share/dict/words
map  :w!<CR>:!aspell check %<CR>:e! %<CR>
map  \1\2<CR>:e! %<CR>
map \1 :w!<CR>
map \2 :!newsbody -qs -n % -p aspell check \%f<CR>

map ,v :sp ~/.vimrc<CR><C-W>_
map <silent> ,V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

filetype on
filetype plugin on
filetype indent on
nmap ,a :GNOMEAlignArguments<CR>

set completeopt=menu,menuone,longest
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

" Make sure coding conventions are not violated for particular cases
" (thanks to Jeff King <peff@peff.net> for the tip via git@vger.kernel.org)
au BufNewFile,BufRead ~/workspace/git/* set noet sts=8 sw=8 ts=8

" Remove trailing whitespace (k0001, #git)
" autocmd BufWritePre *:%s/\s\+$//e

" Thanks to Loïc Minier <lool@dooz.org>, desktop-devel-list for the whitespace indicators
" Addditions from Bastien Nocera <hadess@hadess.net>, via Xavier Claessens <xclaesse@gmail.com>
set list
set listchars=tab:↦\ ,trail:»,extends:↷,precedes:↶,nbsp:% ",eol:•

if has('gui_running')
    set number
    set guioptions-=T
    set guioptions-=m
    set guioptions-=r
    set guioptions-=L
    colorscheme candycode
    set guifont=Deja\ Vu\ Sans\ Mono\ 8
endif

