__powerline() {
    # https://github.com/riobard/bash-powerline/blob/e1b06b9534339b29f657af3cdc0edaaacd27a316/bash-powerline.sh with some modifications

    # Unicode symbols
    readonly PS_SYMBOL_DARWIN=''
    readonly PS_SYMBOL_LINUX='$'
    readonly PS_SYMBOL_OTHER='%'
    readonly GIT_BRANCH_SYMBOL='⑂ '
    readonly GIT_BRANCH_CHANGED_SYMBOL='∆'
    readonly GIT_NEED_PUSH_SYMBOL='⇡'
    readonly GIT_NEED_PULL_SYMBOL='⇣'
    readonly GIT_STAGED_SYMBOL='↗'
    readonly GIT_UNSTAGED_SYMBOL='↘'
    readonly GIT_UNTRACKED_SYMBOL='?'

    # Solarized colorscheme
    readonly FG_BASE03="\[$(tput setaf 8)\]"
    readonly FG_BASE02="\[$(tput setaf 0)\]"
    readonly FG_BASE01="\[$(tput setaf 10)\]"
    readonly FG_BASE00="\[$(tput setaf 11)\]"
    readonly FG_BASE0="\[$(tput setaf 12)\]"
    readonly FG_BASE1="\[$(tput setaf 14)\]"
    readonly FG_BASE2="\[$(tput setaf 7)\]"
    readonly FG_BASE3="\[$(tput setaf 15)\]"

    readonly BG_BASE03="\[$(tput setab 8)\]"
    readonly BG_BASE02="\[$(tput setab 0)\]"
    readonly BG_BASE01="\[$(tput setab 10)\]"
    readonly BG_BASE00="\[$(tput setab 11)\]"
    readonly BG_BASE0="\[$(tput setab 12)\]"
    readonly BG_BASE1="\[$(tput setab 14)\]"
    readonly BG_BASE2="\[$(tput setab 7)\]"
    readonly BG_BASE3="\[$(tput setab 15)\]"

    readonly FG_YELLOW="\[$(tput setaf 3)\]"
    readonly FG_ORANGE="\[$(tput setaf 9)\]"
    readonly FG_RED="\[$(tput setaf 1)\]"
    readonly FG_MAGENTA="\[$(tput setaf 5)\]"
    readonly FG_VIOLET="\[$(tput setaf 13)\]"
    readonly FG_BLUE="\[$(tput setaf 4)\]"
    readonly FG_CYAN="\[$(tput setaf 6)\]"
    readonly FG_GREEN="\[$(tput setaf 2)\]"

    readonly BG_YELLOW="\[$(tput setab 3)\]"
    readonly BG_ORANGE="\[$(tput setab 9)\]"
    readonly BG_RED="\[$(tput setab 1)\]"
    readonly BG_MAGENTA="\[$(tput setab 5)\]"
    readonly BG_VIOLET="\[$(tput setab 13)\]"
    readonly BG_BLUE="\[$(tput setab 4)\]"
    readonly BG_CYAN="\[$(tput setab 6)\]"
    readonly BG_GREEN="\[$(tput setab 2)\]"

    readonly DIM="\[$(tput dim)\]"
    readonly REVERSE="\[$(tput rev)\]"
    readonly RESET="\[$(tput sgr0)\]"
    readonly BOLD="\[$(tput bold)\]"

    # what OS?
    case "$(uname)" in
        Darwin)
            readonly PS_SYMBOL=$PS_SYMBOL_DARWIN
            ;;
        Linux)
            readonly PS_SYMBOL=$PS_SYMBOL_LINUX
            ;;
        *)
            readonly PS_SYMBOL=$PS_SYMBOL_OTHER
    esac

    __git_info() {
        [ -x "$(/usr/bin/which git)" ] || return    # git not found

        # local git_eng="env LANG=C git"   # force git output in English to make our work easier
        local git_eng="git"
        # get current branch name or short SHA1 hash for detached head
        local branch="$($git_eng symbolic-ref --short HEAD 2>/dev/null || $git_eng describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return  # git branch not found

        local marks

        # how many commits local branch is ahead/behind of remote?
        local git_status="$($git_eng status --porcelain --branch)"
        local aheadN="$(echo $git_status | grep -o '\[ahead [[:digit:]]\]\+' | grep -o '[[:digit:]]\+')"
        local behindN="$(echo $git_status | grep -o '\[behind [[:digit:]]\]\+' | grep -o '[[:digit:]]\+')"
        [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
        [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"

        # get working tree changes counts
        NL='
'
        case $git_status in
          *"$NL"*)
            local stagedN="$(echo "$git_status" | egrep "^[MADRC]" | wc -l | grep -o '[[:digit:]]\+')"
            local unstagedN="$(echo "$git_status" | egrep "^[ MADRC][MD]" | wc -l | grep -o '[[:digit:]]\+')"
            local untrackedN="$(echo "$git_status" | egrep "^[?]" | wc -l | grep -o '[[:digit:]]\+')"
            ;;
          *)
            local stagedN=0
            local unstagedN=0
            local untrackedN=0
            ;;
        esac
        local status_counts="$GIT_STAGED_SYMBOL$stagedN $GIT_UNSTAGED_SYMBOL$unstagedN $GIT_UNTRACKED_SYMBOL$untrackedN"

        # get repo name
        local repo_name="$(basename `git rev-parse --show-toplevel`)"

        # print the git branch segment without a trailing newline
        printf " $repo_name $GIT_BRANCH_SYMBOL$branch$marks [$status_counts] "
    }

    # https://github.com/riobard/bash-powerline/pull/11/files
    __rvm() {
      if [ -z "${RUBY_VERSION}" ] ; then
        return
      else
        printf " $RUBY_VERSION "
      fi
    }

    __nvm() {
      if [ -d "$NVM_DIR" ] ; then
        printf " node-$(nvm_version) "
      else
        return
      fi
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly.
        if [ $? -eq 0 ]; then
            local BG_EXIT="$BG_GREEN"
        else
            local BG_EXIT="$BG_RED"
        fi

        local GIT_INFO="$(__git_info)"
        if [ -n "$GIT_INFO" ]; then
          if [[ "$(git rev-parse --show-toplevel)" = "$(pwd)" ]]; then
            local PS1_WD="-->"
          else
            local PS1_WD="\W"
          fi
        else
          local PS1_WD="\w"
        fi

        PS1="$BOLD$BG_CYAN$FG_BASE3 \t $RESET"
        PS1+="$BG_BASE3$FG_BASE02 \u : \# $RESET"
        PS1+="$BG_ORANGE$FG_BASE3$(__rvm)$RESET"
        PS1+="$BG_BASE2$FG_BASE02$(__nvm)$RESET"
        PS1+="$BG_BASE03$FG_BASE3 $PS1_WD $RESET"
        PS1+="$BG_BLUE$FG_BASE3$GIT_INFO$RESET"
        PS1+="$BG_EXIT$FG_BASE3 $PS_SYMBOL $RESET "
    }

    PROMPT_COMMAND="ps1;$PROMPT_COMMAND"
}

__powerline
unset __powerline
