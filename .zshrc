# As advised in the emerge log by the always helpful Gentoo team
autoload -U compinit promptinit
compinit
promptinit; prompt gentoo

# More recommendations from Gentoo
# http://www.gentoo.org/doc/en/zsh.xml
zstyle ":completion::complete:*" use-cache 1
zstyle ":completion:*:descriptions" format "%U%B%d%b%u"
zstyle ":completion:*:warnings" format "%BSorry, no matches for: %d%b"

