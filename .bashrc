
# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# TODO(elpiloto): Only add this if we're on WSL.
# see here: https://techcommunity.microsoft.com/t5/windows-dev-appconsult/running-wsl-gui-apps-on-windows-10/ba-p/1493242
export DISPLAY="`grep nameserver /etc/resolv.conf | sed 's/nameserver //'`:0"

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# change directories by typing dir_name<ENTER>
shopt -s autocd

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# Use vim for our man pages
export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma fdm=indent' -\""

export EDITOR='vim'


# Bash Completion:
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# TODO(elpiloto): Add check here to enable osx.
# tmux bash completion in osx + homebrew
#if [ -e /usr/local/Cellar/tmux/1.9a/etc/bash_completion.d/tmux ]
if [ -e  /usr/local/etc/bash_completion.d/tmux ] 
then
       source /usr/local/etc/bash_completion.d/tmux
fi


# TODO(elpiloto): Make this OSX specific.
# Set CLICOLOR if you want Ansi Colors in iTerm2 
export CLICOLOR=1

export VIM_DIR="$HOME/.vim_modular/"
# Define these aliases here because they depend on $VIM_DIR
alias vimrc="vim $VIM_DIR/.vimrc"
alias nvimrc="nvim $VIM_DIR/.vimrc"
alias initvim="vim /home/piloto/.config/nvim/init.vim"
alias ninitvim="nvim /home/piloto/.config/nvim/init.vim"

# We manage our fzf installation purely from vim fzf plugin.
# This is a bit awkward because it means our fzf binary lives in our vim directory.
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Simple prompt, best with nerd font for arrow ligatures.
PS1=$(echo -e '\[\e[35m\]\w\[\e[m\]')
PS1=$PS1' '$(echo -e '\[\e[32m\]-->\[\e[m\] ')


