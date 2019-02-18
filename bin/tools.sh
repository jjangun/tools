#/bin/bash
MType=`uname`

export PATH=$PATH:$HOME/.tools/bin

# sources {{{
source acd_func.sh
# }}}

# for zsh {{{
if [[ "$SHELL" =~ "zsh" ]]; then
    prompt_context() {
        if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
            prompt_segment black default "%(!.%{%F{yellow}%}.)$USER"
        fi
    }
fi
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

