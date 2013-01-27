shopt login_shell >/dev/null || . ~/.bash_profile

# returns if not running interactively
[ -z "$PS1" ] && return

#export HISTCONTROL=ignoredups
#export HISTCONTROL=ignoreboth

# appends to the histfile instead of overwriting
shopt -s histappend

# bash should check the window size after every command
shopt -s checkwinsize

# bash matches filenames in a case-insensitive fashion when  performing
# pathname expansion
shopt -s nocaseglob

# allows recursive matching in cd via ** (if supported)
shopt -s autocd 2> /dev/null

# allows recursive globbing via **
shopt -s globstar 2> /dev/null


# minor  errors in the spelling of a directory component in a cd command will
# be corrected
shopt -s cdspell

# picks the best available ls command
if [[ -x /opt/local/bin/gls || -x /usr/local/bin/gls ]]; then
    # macports or homebrew
    _ls() { gls --color=always -bCFhG "$@" | less -E -R; }
elif [[ -x /opt/bin/ls ]]; then
    # qnap ipkg
    _ls() { /opt/bin/ls --color=always -bCFhG "$@" | less -E -R; }
else
    _ls() { \ls -bCFhG "$@" | less -E -R; }
fi

alias ls="_ls"
alias ll="_ls -l"
alias la="_ls -la"

export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# sudo allows aliases
alias sudo='sudo '

# screen will always try to reattach to some detached session
alias scr="screen -d -RR"

# tunnels ssh through a local socks
alias sscp="scp -o 'ProxyCommand connect -S 127.0.0.1:20000 %h %p'"
alias sssh="ssh -o 'ProxyCommand connect -S 127.0.0.1:20000 %h %p'"

# links through a local socks
alias slinks="links -socks-proxy localhost:20000"

# tinyproxy
alias tinyproxy-start="sudo tinyproxy -c ~/etc/tinyproxy.conf"
alias tinyproxy-stop="sudo killall tinyproxy"

# mysql
#alias mysql=mysql5
#alias mysqladmin=mysqladmin5
#alias mysql-start="sudo /opt/local/share/mysql5/mysql/mysql.server start"
#alias mysql-stop="sudo /opt/local/share/mysql5/mysql/mysql.server stop"

# airport command
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"

# xargs with one parameter only
alias xargs1="xargs -n 1"

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# prompt command for use in screen multiplexer
case $TERM in
    screen)
        export PROMPT_COMMAND='echo -n -e "\033k\033\\"'
        ;;
esac

umask 022

cd

# autojump
if [ -f /opt/local/etc/profile.d/autojump.sh ]; then
    . /opt/local/etc/profile.d/autojump.sh
fi
