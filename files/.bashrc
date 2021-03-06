# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%Y-%m-%d %T --- "

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
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

export LS_COLORS='di=38;5;33:ln=38;5;44:so=38;5;44:pi=38;5;44:bd=38;5;44:or=38;5;124:cd=38;5;172:ex=38;5;40:fi=38;5;184:no=38;5;245'
PATH="$HOME/.local/bin:$PATH"
# Goal to organize dotfiles
# https://github.com/mathiasbynens/dotfiles
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

#setting the terminal title to PWD # NOT WORKING if using with tmux
PS1="\[\033]0;\w\007\]";
PS1+="\n[\D{%m/%d/%y - %r}] "; # date and time
PS1+="\[\033[32m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\]";
PS1+=" $ ";
export PS1;
export TERM=xterm-256color
export EDITOR=vim

# My custom aliases
alias ll="lsd -la"
alias ssha='eval $(ssh-agent) && ssh-add'
alias rmaf='rm -rf $(ls -la | awk "{ print $9 }")'

# Easier navigation: .., ..., ...., ....., ~ and -
alias \
    ..="cd .." \
    ...="cd ../.." \
    ....="cd ../../.." \
    .....="cd ../../../.." \
    -="cd -"

# Tmux related aliases
alias \
    tn="tmux -u new" \
    tnn="tmux -u new -s" \
    ta="tmux -u attach" \
    tt="vim ~/.tmux.conf"
    
# transmission related aliases
alias \
   tmd="transmission-daemon" \
   tmr="transmission-remote"

# ranger related aliases
# this allows ranger to close ang go back to cli on the last directory where ranger was closed
alias r='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

# bashrc related aliases
alias \
    bb="vim ~/.bashrc"\
    bs="source ~/.bashrc && echo -e 'bashrc sourced'"

# vimrc related aliases
alias \
    v="vim" \
    vv="vim ~/.vimrc" \
    vs="source ~/.vimrc && echo - 'vimrc sourced'"

# docker related aliases
alias \
   d="docker" \
   drin='docker rmi $(docker images | grep none | awk "{ print $3 }")' \
   dmgs='docker images' \
   dps='docker ps' \
   dp='docker pull' \
   dr='docker run'

# docker-compose related aliases
alias \
   dc="docker-compose" \
   dcu='docker-compose up' \
   dcud='docker-compose up -d' \
   dcd='docker-compose down' 

# ansible related aliases
alias \
    a="ansible all" \
    ap="ansible-pull"\
    apb="ansible-playbook" \
    aping='ansible all -m ping'

# kubectl related aliases
alias \
   k="kubectl" \
   kall='kubectl get all -A'

# istio related aliases
alias i="istioctl"

# helm related aliases
alias \
  h="helm" \
  hls='helm ls' \
  hi='helm install' \
  hu='helm uninstall'

# minikube related aliases
alias \
   m='minikube' \
   mstat='minikube status' \
   mdenv='eval $(minikube -p minikube docker-env)' \
   mdenvu='eval $(minikube -p minikube docker-env --unset)' \
   mssh='minikube ssh'
   
# git related aliases
alias \
   g='git' \
   gc='git clone' \
   gagc='git add . && git commit -m' \
   gstat='git status' \
   gl='git log' \
   gpo='git push origin -u'
   
# curl related aliases
alias \
   c='curl' \
   cstat='curl -o /dev/null -s -w "%{http_code}\n"' 

# minikube related aliases

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#bind 'set show-all-if-ambiguous on'
#bind 'TAB:menu-complete'

# nvm script
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# package aliases
alias pip='pip3.10'

#set -o vi
eval "$(starship init bash)"
