if command -v vim >/dev/null
    set -gx EDITOR vim
else
    set -gx EDITOR vi
end
