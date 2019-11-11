# Setting PATH for Python 3.5
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
export PATH

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH

# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"

export PATH

# Custom bin folder in home folder
PATH="${HOME}/bin:${PATH}"
export PATH

# Custom aliases
alias ls='ls -GFh'
alias bc='cd /Users/Yvan/OneDrive/University/19\ SS/1.\ Bachelor\ Thesis/bachelor-colloquium'

# Custom commands
cs() { cd "$@" && ls; }
nd() { ("$@" && terminal-notifier -title "$1" -message "Task completed!") || terminal-notifier -title "$1" -message "Task failed"; }

# PS1 colors and to make it shorter
# backup original version
# export PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ "

export PS1="\[\033[36m\]\u\[\033[m\]:\[\033[33;1m\]\w\[\033[m\]\$ "
export CLICOLOR=1
export LSCOLORS=exfxbxdxcxegedabagacad

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/Yvan/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/Yvan/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/Yvan/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/Yvan/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Locale issues with homebrew
export LC_ALL=en_US.UTF-8

# ZHAW aliases
zhaw() {
    if [ -z "$1" ]; then
        ssh saty@dgx2.cloudlab.zhaw.ch;
    elif [ "$1" == "1" ]; then
        ssh saty@dgx.cloudlab.zhaw.ch;
    elif [ "$1" == "sh" ]; then
	echo "Forwarding port "$2" from dgx2 server" && ssh -L 127.0.0.1:8888:0.0.0.0:$2 -N saty@dgx2.cloudlab.zhaw.ch;
    elif [ "$1" == "sh1" ]; then
	echo "Forwarding port "$2" from dgx server" && ssh -L 127.0.0.1:8888:0.0.0.0:$2 -N saty@dgx.cloudlab.zhaw.ch;
    elif [ "$1" == "tb" ]; then
        echo "Forwarding TensorBoard port from dgx server" && ssh -L 127.0.0.1:5000:0.0.0.0:9175 -N saty@dgx2.cloudlab.zhaw.ch;
    elif [ "$1" == "sync" ]; then
	rsync -avz --delete /Users/Yvan/OneDrive/ZHAW/Sync/ saty@dgx2.cloudlab.zhaw.ch:/cluster/home/saty/sync;
    else
        echo "illegal arguments given";
    fi
}

source $HOME/.qt_aliases
