if command -v lesspipe.sh >/dev/null; and command -v brew >/dev/null
    set -gx LESSOPEN "| "(brew --prefix)"/bin/lesspipe.sh %s"
    set -gx LESS_ADVANCED_PREPROCESSOR 1
end
