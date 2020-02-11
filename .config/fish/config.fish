set PATH /Users/Yvan/miniconda3/bin /Users/Yvan/bin $PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/Yvan/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

set -gx LC_ALL en_US.UTF-8

# iterm shell integration
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

# Color scheme for theme
set theme_color_scheme terminal2-light-black

# Set theme settings
set -g theme_dsplay_cmd_duration no

# dotfiles git
alias dotfiles "/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME" 

# Emoji settings
set fish_emoji_width 2
set fish_ambiguous_width 1

# Sudo alias
alias 😠 "sudo"
