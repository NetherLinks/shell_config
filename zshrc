# MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"

#oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
plugins=(git osx aws docker kubectl macports node npm ruby rvm tig tmux yarn)
DISABLE_MAGIC_FUNCTIONS=true
source $ZSH/oh-my-zsh.sh

# Custom
export MANPATH="/usr/local/man:/opt/local/share/man:$MANPATH"
export LANG=ja_JP.UTF-8
export LC_ALL=ja_JP.UTF-8
export EDITOR=vim
export HISTFILESIZE=10000000
export HISTSIZE=10000000
export SAVEHIST=10000000
export PATH="$HOME/.bin:$PATH"

function cd ()
{
    builtin cd "$@" && print -rD $PWD;
}

function ssh ()
{
    SSH=`/usr/bin/which ssh`
    $SSH -v -t $@ "tmux attach -t ${USER:0:18} || tmux new -s ${USER:0:18} \"zsh -l\" || zsh -l || bash -l"
}

function finder ()
{
    open -a Finder ./
}

source ./.zsh-prompt.sh

# Aliases
alias lf="ls -AFGlhOT"
alias pod='pod --verbose'
alias rm='rm -i'
alias rsyncap='rsync -aP'
alias preview='open -a Preview'
alias which='which -a'
alias port='port -v'
hash -d code="$HOME/code"

# Libraries
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

export PATH="$PATH:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
