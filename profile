export LANG="ja_JP.UTF-8"
export LC_ALL="ja_JP.UTF-8"

HISTFILESIZE=10000000
HISTSIZE=10000000
export CLICOLOR=1

alias lf="ls -AFGlhOT"
alias finder="open -a Finder ./"
alias finderShowHidden='defaults write com.apple.finder AppleShowAllFiles 1'
alias finderHideHidden='defaults write com.apple.finder AppleShowAllFiles 0'
alias startApache='sudo apachectl start'
alias stopApache='sudo apachectl stop'
alias pod='pod --verbose'
alias rm='rm -i'
alias rsyncap='rsync -aP'
alias preview='open -a "Preview"'
alias which='which -a'
alias port='port -v'
alias ..='cd ../'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ffprobe='ffprobe -v debug'
alias stree='/Applications/SourceTree.app/Contents/Resources/stree'

function cd ()
{
    builtin cd "$@" && pwd;
}

function ssh ()
{
    SSH=`/usr/bin/which ssh`
    $SSH -v -t $@ "tmux attach -t ${USER::18} || tmux new -s ${USER::18} || bash -l"
}

export EDITOR=vim

source ~/.bash-powerline.sh
