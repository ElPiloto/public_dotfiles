#!/bin/bash

alias lc="clear && ls"
alias lsd='ls -d .*'
alias tree='tree -C'
alias resource='source ~/.bashrc'
alias gitlc='clear && git status'
lsrd () { ls -clthrd "$1"*/ ; }
lsr () { ls -clthrd "$1"* ; }
lcr () { clear; ls -clthrd "$1"* ; }

# Tmux aliases to make it easy to reattach
alias tmux0='tmux attach -t 0'
alias tmux1='tmux attach -t 1'
alias tmux2='tmux attach -t 2'
alias tmux3='tmux attach -t 3'
alias tmuxls='tmux list-sessions'

alias bashrc='vim ~/.bashrc'
# The following two files might not exist
alias initvim='vim ~/.config/nvim/init.vim'
alias ninitvim='nvim ~/.config/nvim/init.vim'

# Copying/Pasting Files (found this online somewhere but can't recall where :( )
# pair of functions to enable sequential copy and paste of a file:
# copy my_file1 my_file2;
# cd some_dir;
# paste
function copy {
    touch ~/.clipfiles
    for i in "$@"; do
      if [[ $i != /* ]]; then i=$PWD/$i; fi
      i=${i//\\/\\\\}; i=${i//$'\n'/$'\\\n'}
      printf '%s\n' "$i"
    done >> ~/.clipfiles
}

function paste {
    while IFS= read src; do
      cp -Rdp "$src" .
    done < ~/.clipfiles
    rm ~/.clipfiles
}
function swap()
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

