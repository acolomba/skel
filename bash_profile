# paths

# mainly for optware
if [[ -d /opt/bin ]]; then
    export PATH="/opt/bin:${PATH}"
fi

# some enviros for macports, if present
if [[ -d /opt/local ]]; then
    export MANPATH="/opt/local/share/man:${MANPATH}"
    export LD_LIBRARY_PATH="/opt/local/lib:${LD_LIBRARY_PATH}"
fi

# own bins
export PATH="~/bin:${PATH}"

# umask
umask 0002

# constructs bash prompt

if [[ $USER == acolomba || $USER == u1dc39 ]]; then
    # only host for my account
    prompt_host="\h"
else
    # username@host for other accounts
    prompt_host="\u@\h"
fi


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

# history prefs
export HISTSIZE=50000
export HISTCONTROL="erasedups:ignoredups:ignorespace"
export HISTIGNORE="bg:fg:rm *:exit"

# completion
if [[ -f /etc/bash_completion ]]; then
    # linux
    . /etc/bash_completion

    complete -r cd
elif [[ -f /opt/local/etc/bash_completion ]]; then
    # macports
    . /opt/local/etc/bash_completion

    # no expansion of cd ~
    complete -r cd
elif [[ -f /usr/local/etc/bash_completion ]]; then
    # brew
    . /usr/local/etc/bash_completion

    # no expansion of cd ~
    complete -r cd
elif [[ -f /opt/etc/bash_completion ]]; then
    # optware/ipkg
    . /opt/etc/bash_completion

    # no expansion of cd ~
    complete -r cd
fi



# python in local
if [[ -d /usr/local/lib/python ]]; then
    export PYTHONPATH=/usr/local/lib/python
fi

if [[ -d /opt/local ]]; then
    # python path for macports
    export PYTHONPATH=$PYTHONPATH:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages
fi

# editor
export EDITOR=vi

# pager
export LESS="$LESS -i -F -R -X"

# pager syntax highlighting if available (/dev/null instead of -s for compatibility)
if which /opt/local/bin/src-hilite-lesspipe.sh >/dev/null 2>&1; then
    # macports
    export LESSOPEN="| /opt/local/bin/src-hilite-lesspipe.sh %s"
elif which /usr/local/bin/src-hilite-lesspipe.sh >/dev/null 2>&1; then
    # macports
    export LESSOPEN="| /usr/local/bin/src-hilite-lesspipe.sh %s"
fi

# trn
export TRNINIT="-x6ms  +e -m=s -S -XX -B -p"
export REPLYTO="\`echo '@c010mb@!gm@i1.c0m' |tr '!@01' '@aol'\`"


# frotz
if [[ -d ~/Applications/infocom ]]; then
    export ZCODE_PATH=~/Applications/infocom
fi

# if running on Lion, unhides the ~/Library folder
if which sw_vers >/dev/null 2>&1 && [[ $(sw_vers |awk '/ProductVersion/ {print $2}' |sed 's/\([0-9]*\.[0-9]*\)\.[0-9]*/\1/') == '10.7' ]] && which chflags >/dev/null 2>&1; then
    chflags nohidden ~/Library
fi


# sources bashrc for login shells
[[ -f ~/.bashrc ]] && shopt login_shell >/dev/null && . ~/.bashrc

# MacPorts Installer addition on 2011-12-31_at_19:59:18: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.
