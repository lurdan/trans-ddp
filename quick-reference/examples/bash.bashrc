# System-wide .bashrc file for interactive bash(1) shells.
#

shopt -s checkwinsize

### In order to have consistent feel over accounts, 
### I customize this file instead of ~/.bashrc

PS1='\u@\h:\W\$ '

# Some more alias to avoid making mistakes:
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'


# short commands

alias h='history'
alias j="jobs -l"
alias c="clear"
alias m="less"
alias pu="pushd"
alias po="popd"

# You may comment the following lines if you do not want `ls' to be colorized:
export LS_OPTIONS='--color=auto'
eval `dircolors` # set LS_COLORS
alias ll='ls $LS_OPTIONS -labF'
alias l='ls $LS_OPTIONS -AbF'

# useful functions for mc

# does not do ctrl-Z
# mc() { cd $(/usr/bin/mc -P "$@"); }
# use secured temp-file
mc ()
{
    mkdir -p ~/.mc/tmp 2> /dev/null
    chmod 700 ~/.mc/tmp
    MC=~/.mc/tmp/mc-$$
    /usr/bin/mc -P "$@" > "$MC"
    cd "$(cat $MC)"
    rm -f "$MC"
    unset MC;
}
