# paths

# optware
if [[ -d /opt/bin ]]; then
    export PATH="/opt/bin:${PATH}"
fi

# own bins
export PATH="~/bin:${PATH}"

# prefixes of installed software, config, etc.
# ( system local/homebrew macports ipkg )
prefixes=( "" /usr/local /opt/local /opt )

# history prefs
export HISTSIZE=50000
export HISTCONTROL="erasedups:ignoredups:ignorespace"
export HISTIGNORE="bg:fg:rm *:exit"


# completion
for prefix in "${prefixes[@]}"; do
    if [[ -f ${prefix}/etc/bash_completion ]]; then
        . "${prefix}/etc/bash_completion"

        # no expansion of cd ~
        complete -r cd
    fi
done

# python in local
if [[ -d /usr/local/lib/python ]]; then
    export PYTHONPATH=/usr/local/lib/python
fi

# editor
export EDITOR=vim

# pager
export LESS="$LESS -i -F -R -X"

# pager syntax highlighting if available (/dev/null instead of -s for compatibility)
for prefix in "${prefixes[@]}"; do
    if [[ -x ${prefix}/bin/src-hilite-lesspipe.sh ]]; then
        export LESSOPEN="| ${prefix}/bin/src-hilite-lesspipe.sh %s"
    fi
done

# trn
export TRNINIT="-x6ms  +e -m=s -S -XX -B -p"
export REPLYTO="\`echo '@c010mb@!gm@i1.c0m' |tr '!@01' '@aol'\`"


# frotz
if [[ -d ~/Applications/infocom ]]; then
    export ZCODE_PATH=~/Applications/infocom
fi

# if running on Lion, unhides the ~/Library folder
if [[ $(uname) = 'Darwin' ]]; then
    # picks up the os x version
    sw_vers=$(sw_vers |awk '/ProductVersion/ {print $2}' |sed 's/\([0-9]*\.[0-9]*\)\.[0-9]*/\1/')

    if [[ $sw_vers = '10.7' || $sw_vers = '10.8' ]]; then
        chflags nohidden ~/Library
    fi
fi


# if not running bash 4, tries to find one
if [[ $BASH_VERSINFO != "4" ]]; then
    for prefix in "${prefixes[@]}"; do
        if [[ -x ${prefix}/bin/bash && $(${prefix}/bin/bash -c 'echo $BASH_VERSINFO') = "4" ]]; then
            exec ${prefix}/bin/bash
        fi
    done
fi

# sources bashrc for login shells
[[ -f ~/.bashrc ]] && shopt login_shell >/dev/null && . ~/.bashrc