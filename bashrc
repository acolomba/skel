#shopt login_shell >/dev/null || . ~/.bash_profile

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

# ls command options and helpers

# sets default options for the ls command
if [[ $(uname) = 'Darwin' ]]; then
    export CLICOLOR_FORCE=1
    ls_opts="-bCFhG"
else
    ls_opts="--color=always -bCFh"
fi

# ls colors
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

# helpers

# ls
_ls() { \ls ${ls_opts} "$@" | less -E -R -X; }
alias ls="_ls"
alias ll="_ls -l"
alias la="_ls -la"

# man
man() {
    env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}

# autojump
prefixes=( /usr/local )
[[ -s /usr/local/etc/autojump.sh ]] && . /usr/local/etc/autojump.sh


# screen helper that will always try to reattach to some detached session
alias scr="screen -d -RR"


# tunnels ssh through a local socks
alias sssh="ssh -o 'ProxyCommand connect -S 127.0.0.1:20000 %h %p'"
alias sscp="scp -o 'ProxyCommand connect -S 127.0.0.1:20000 %h %p'"


# links through a local socks
alias slinks="links -socks-proxy localhost:20000"


# tinyproxy
alias tinyproxy-start="sudo tinyproxy -c ~/etc/tinyproxy.conf"
alias tinyproxy-stop="sudo killall tinyproxy"


# airport command on os x
if [[ $(uname) = 'Darwin' ]]; then
    alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
fi


# xargs with one parameter only
alias xargs1="xargs -n 1"


# bash prompt

# username@host for other accounts
prompt_host="\u@\h"

# shortens prompt_host if known username
usernames=( acolomba u1dc39 )
for username in "${usernames[@]}"; do
    if [[ $USER = $username ]]; then
        # only host for my account
        prompt_host="\h"
    fi
done

# suffix depends on privs
if [[ $(id -u) == 0 ]]; then
    # pound for root
    prompt_suffix="#"
else
    # gt otherwise
    prompt_suffix=">"
fi

# some colors
start_host_color="\[\e[1;31m\]"
end_host_color="\[\e[m\]"
start_pwd_color="\[\e[1;34m\]"
end_pwd_color="\[\e[m\]"

# the prompt
export PS1="${start_host_color}${prompt_host}${end_host_color}:${start_pwd_color}\w${end_pwd_color} ${prompt_suffix} "

# prompt command for use in screen multiplexer
case $TERM in
    screen)
        export PROMPT_COMMAND='echo -n -e "\033k\033\\"'
        ;;
esac


# umask
umask 077

# cd home
cd

