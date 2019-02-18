#/bin/bash
MType=`uname`

export PATH=:$HOME/.tools/bin:$HOME/.tools/bin/global/bin:$PATH

# sources {{{
source acd_func.sh
# }}}

# aliases {{{
alias cd..='cd ..'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# }}}

# minicom {{{
export MINICOM="-m -c on"
# }}}

# etc {{{
export TERM='xterm-256color'
# }}}

