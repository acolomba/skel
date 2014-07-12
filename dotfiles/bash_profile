# paths

# prefixes of installed software, config, etc.
# ( system local/homebrew macports ipkg )
# NOTE some systems have /usr/local/bin in the path already, but here we want
# to make sure it's before other system-defined path entries
prefixes=( "" /usr/local /opt/local /opt )

# if not running bash 4, tries to find one
if [[ $BASH_VERSINFO != "4" ]]; then
    for prefix in "${prefixes[@]}"; do
        if [[ -x ${prefix}/bin/bash && $(${prefix}/bin/bash -c 'echo $BASH_VERSINFO') = "4" ]]; then
            exec ${prefix}/bin/bash --login
        fi
    done
fi

for prefix in "${prefixes[@]}"; do
    if [[ -d ${prefix}/bin ]]; then
        export PATH="${prefix}/bin:${PATH}"
    fi
done

# own bins
export PATH="~/bin:${PATH}"

# history prefs
export HISTSIZE=50000
export HISTCONTROL="erasedups:ignoredups:ignorespace"
export HISTIGNORE="bg:fg:rm *:exit"

# completion
for prefix in "${prefixes[@]}"; do
    if [[ -f ${prefix}/etc/bash_completion ]]; then
        . ${prefix}/etc/bash_completion
    elif [[ -f ${prefix}/share/bash-completion/bash_completion ]]; then
        . ${prefix}/share/bash-completion/bash_completion
    fi
done

# no expansion of cd ~
complete -r cd


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

# sources bashrc for login shells
[[ -f ~/.bashrc ]] && shopt login_shell >/dev/null && . ~/.bashrc
