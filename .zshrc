# As advised in the emerge log by the always helpful Gentoo team
autoload -U compinit promptinit
compinit
promptinit; prompt gentoo

# More recommendations from Gentoo
# http://www.gentoo.org/doc/en/zsh.xml
zstyle ":completion::complete:*" use-cache 1
zstyle ":completion:*:descriptions" format "%U%B%d%b%u"
zstyle ":completion:*:warnings" format "%BSorry, no matches for: %d%b"

# Allow Ctrl-x f to disable cleverness in tab-selection
# Thanks to ft in #git
zle -C complete-files complete-word _generic;
zstyle ':completion:complete-files:*' completer _files
bindkey '^xf' complete-files

# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
# Ripped from the Gentoo skeleton bashrc I have
if [[ -f ~/.dir_colors ]]; then
    eval `dircolors -b ~/.dir_colors`
else
    eval `dircolors -b /etc/DIR_COLORS`
fi
alias ls="ls --color=auto"

# Useful function that, if vi is invoked on a list of files, will check
# and execute "sudo vi" on them if owned by root.
# Thanks to William Scott, originally via Gary Kerbaugh
# http://xanana.ucsc.edu/~wgscott/xtal/wiki/index.php/Why_zsh_Should_Be_the_Default_Shell_on_OS_X
function vim {
    LIMIT=$#
    for ((i = 1; i <= $LIMIT; i++)) do
        eval file="\$$i"
        if [[ -e $file && ! -O $file ]] then
            otherfile=1
        fi
    done
    if [[ $otherfile = 1 ]] then
        sudo vim "$@"
    else
        command vim "$@"
    fi
}
