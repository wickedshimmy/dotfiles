# As advised in the emerge log by the always helpful Gentoo team
autoload -U compinit promptinit
compinit
promptinit

# Moved this out of the setprompt() fn
# Thanks to littleprince.zh (http://w-a-n.cn)
autoload colors
zmodload zsh/terminfo
if [[ "$terminfo[colors]" -gt 8 ]]; then
    colors
fi

# More recommendations from Gentoo
# http://www.gentoo.org/doc/en/zsh.xml
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'

# Allow Ctrl-x f to disable cleverness in tab-selection
# Thanks to ft in #git
zle -C complete-files complete-word _generic;
zstyle ':completion:complete-files:*' completer _files
bindkey '^xf' complete-files

setopt histignoredups
bindkey ^R history-incremental-search-backward

# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
# Ripped from the Gentoo skeleton bashrc I have
if [[ -f ~/.dir_colors ]]; then
    eval $(dircolors -b ~/.dir_colors)
else
    eval $(dircolors -b /etc/DIR_COLORS)
fi
alias ls='ls --color=auto'

# precmd is a built-in zsh function that is called on each redraw
# Used here to set the dynamic variables (GITBRANCH, etc.)
# (More thanks for Aaron Toponce)
function precmd {
    # Ripped from git's bash completion scripts, via Aaron Toponce
    git_ps1 () {
        if which git > /dev/null; then
            local g="$(git rev-parse --git-dir 2>/dev/null)"
            if [ -n "$g" ]; then
                local o
                local b
                if [ -d "$g/rebase-apply" ]; then
                    if [ -f "$g/rebase-apply/rebasing" ]; then
                        o="|REBASE"
                    elif [ -f "$g/rebase-apply/applying" ]; then
                        o="|AM"
                    else
                        o="|AM/REBASE"
                    fi
                    b="$(git symbolic-ref HEAD 2>/dev/null)"
                elif [ -f "$g/rebase-merge/interactive" ]; then
                    o="|REBASE-i"
                    b="$(cat "$g/rebase-merge/head-name")"
                elif [ -d "$g/rebase-merge" ]; then
                    o="|REBASE-m"
                    b="$(cat "$g/rebase-merge/head-name")"
                elif [ -f "$g/MERGE_HEAD" ]; then
                    o="|MERGING"
                    b="$(git symbolic-ref HEAD 2>/dev/null)"
                else
                    if [ -f "$g/BISECT_LOG" ]; then
                        o="|BISECTING"
                    fi
                    if ! b="$(git symbolic-ref HEAD 2>/dev/null)"; then
                        if ! b="$(git describe --exact-match HEAD 2>/dev/null)"; then
                            b="$(cut -c1-7 "$g/HEAD")..."
                        fi
                    fi
                fi
                if [ -n "$1" ]; then
                    printf "$1" ${b##refs/heads/}$o
                else
                    printf "%s" ${b##refs/heads/}$o
                fi
            fi
        else
            printf ""
        fi
    }
    GITBRANCH=" $(git_ps1)"

    # Keeping prompt name from wrapping beyond terminal width
    # From Phil Gold (http://aperiodic.net/phil/prompt/)
    # Again via Aaron Toponce
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1))

    local PROMPTSIZE=${#${(%):--- %D{%R.%S %a %b %d %Y}\! }}
    local PWDSIZE=${#${(%):-%~}}

    if [[ "$PROMPTSIZE + $PWDSIZE" -gt $TERMWIDTH ]]; then
        (( PR_PWDLEN = $TERMWIDTH - $PROMPTSIZE ))
    fi
}

# Enable vi keybindings
bindkey -v
function zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/ xx}/(main|viins)/}"
    zle reset-prompt
}
zle -N zle-keymap-select

# Prompt design and accompanying subfunctions from Aaron Toponce
# http://pthree.org/wp-content/uploads/2008/11/zsh_ps1.txt
setprompt () {
    # Need this, so the prompt will work
    setopt prompt_subst

    colors

    # Load colors into the environment and set them properly
    for COLOR in RED GREEN YELLOW WHITE BLACK BLUE CYAN; do
        eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
        eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
    done
    PR_RESET="%{$reset_color%}"

    # Set the prompt
    PROMPT='%B${PR_BRIGHT_BLACK}<${PR_RESET}${PR_RED}<${PR_BRIGHT_RED}<%b\
${PR_RESET}${PR_BRIGHT_GREEN} %n@%m ${PR_RESET}${PR_BRIGHT_BLUE}%${PR_PWDLEN}<..<%~%<<${PR_RESET}${PR_BRIGHT_RED}${GITBRANCH}\

${PR_BRIGHT_BLACK}>${PR_RESET}${PR_GREEN}>${PR_BRIGHT_GREEN}>\
${PR_RESET} '

    PROMPT2='${PR_BRIGHT_BLACK}>${PR_RESET}${PR_GREEN}>${PR_BRIGHT_GREEN}>\
${PR_RESET} %_ ${PR_BRIGHT_BLACK}>${PR_RESET}${PR_GREEN}>\
${PR_BRIGHT_GREEN}>${PR_RESET} '
}

setprompt

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
