# System-wide .bashrc file for interactive bash(1) shells.
#

shopt -s checkwinsize

### In order to have consistent feel over accounts, 
### I customize this file instead of ~/.bashrc

PS1='\u@\h:\W\$ '

# Some more aliases to avoid making mistakes:
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

psgrep()
{
	ps aux | grep $1 | grep -v grep
}

#
# This is a little like `zap' from Kernighan and Pike
#

pskill()
{
	local pid

	pid=$(ps -ax | grep $1 | grep -v grep | awk '{ print $1 }')
	echo -n "killing $1 (process $pid)..."
	kill -9 $pid
	echo "slaughtered."
}

function chmog()
{
	if [ $# -lt 4 ] ; then
		echo "usage: chmog mode owner group file ..."
		return 1
	else
		chmod $1 $4 $5 $6 $7 $8 $9
		chown $2 $4 $5 $6 $7 $8 $9
		chgrp $3 $4 $5 $6 $7 $8 $9
	fi
}

# Some useful aliases.
#alias texclean='rm -f *.toc *.aux *.log *.cp *.fn *.tp *.vr *.pg *.ky'
alias clean='ls -AF;
	echo -n "Really clean this directory? (y/N) ";
	read yorn;
	if [ "$yorn" = "y" ]; then
	   rm -f \#* *~ .*~ *.bak .*.bak  *.tmp .*.tmp core a.out;
	   echo "Cleaned.";
	else
	   echo "Not cleaned.";
	fi'

