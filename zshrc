# MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

#oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git osx aws docker kubectl macports node npm ruby rvm tig tmux yarn)
source $ZSH/oh-my-zsh.sh

# Custom
export MANPATH="/usr/local/man:/opt/local/share/man:$MANPATH"
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export EDITOR=vim
export HISTFILESIZE=10000000
export HISTSIZE=10000000
export SAVEHIST=10000000

function cd ()
{
    builtin cd "$@" && print -rD $PWD;
}

function ssh ()
{
    SSH=`/usr/bin/which ssh`
    $SSH -v -t $@ "tmux attach -t ${USER::18} || tmux new -s ${USER::18} || bash -l"
}

source ./.zsh-prompt.sh

# Aliases
alias lf="ls -AFGlhOT"
alias finder="open -a Finder ./"
alias finderShowHidden='defaults write com.apple.finder AppleShowAllFiles 1'
alias finderHideHidden='defaults write com.apple.finder AppleShowAllFiles 0'
alias pod='pod --verbose'
alias rm='rm -i'
alias rsyncap='rsync -aP'
alias preview='open -a "Preview"'
alias which='which -a'
alias port='port -v'
alias stree='/Applications/SourceTree.app/Contents/Resources/stree'

# Libraries
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PATH="$PATH:$HOME/.rvm/bin"
