set PATH /Users/Yvan/miniconda3/bin /Users/Yvan/bin $PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/Yvan/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

set -gx LC_ALL en_US.UTF-8

#set fish_greeting

test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

set theme_color_scheme terminal2-light-black

alias dotfiles "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
