let g:snips_author = 'Matt Enright'
let g:snips_author_mail = 'awickedshimmy@gmail.com'

set ruler
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

nmap <silent> <C-v> :set paste<CR>"*p:set nopaste<CR>

map  :w!<CR>:!aspell check %<CR>:e! %<CR>
map  \1\2<CR>:e! %<CR>
map \1 :w!<CR>
map \2 :!newsbody -qs -n % -p aspell check \%f<CR>

map ,v :sp ~/.vimrc<CR><C-W>_
map <silent> ,V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

set fdm=marker fmr=#region,#endregion

filetype on
filetype plugin on
filetype indent on

set ofu=syntaxcomplete
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

set grepprg=grep\ -nH\ $*
" Use git-grep for searching files in same repository
" Thanks to Björn Steinbrink (doener in #git) for the tip
func! GitGrep (...)
    let save = &grepprg
    set grepprg=git\ grep\ -n\ $*
    let s = 'grep'
    for i in a:000
        let s = s . ' ' . i
    endfor
    exe s
    let &grepprg = save
endfun
command! -nargs=? G call GitGrep (<f-args>)

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
    set guioptions-=T
    set guioptions-=m
    set guioptions-=r
    set guioptions-=L
    colorscheme desert
    set guifont=Droid\ Sans\ Mono\ 9
endif

"#region Python IDE features
"autocmd FileType python set omnifunc=pythoncomplete#Complete
"inoremap <Nul> <C-x><C>

"Error checking
autocmd BufRead *.py set makeprg=python\ -c\ \"import\ py_compile,sys;\ sys.stderr=sys.stdout;\ py_compile.compile(r'%')\"
autocmd BufRead *.py set efm=%C\ %,%#,%A\ \ File\ \"%f\F\\,\ line\ %l%,%#,%Z%[%^\ ]%\\@=%m

python << EOL
import vim
def EvaluateCurrentRange():
    eval (compile ('\n',join (vim.current.range),'','exec'), globals ())
EOL

map <C-h> :py EvaluateCurrentRange()
"#endregion
