export VIRTUAL_ENV_DISABLE_PROMPT=1

__powerline() {
    # Unicode symbols
    PS_SYMBOL_DARWIN=''
    PS_SYMBOL_LINUX='$'
    PS_SYMBOL_OTHER='%'
    GIT_BRANCH_SYMBOL='⑂ '
    GIT_BRANCH_CHANGED_SYMBOL='∆'
    GIT_NEED_PUSH_SYMBOL='⇡'
    GIT_NEED_PULL_SYMBOL='⇣'
    GIT_STAGED_SYMBOL='↗'
    GIT_UNSTAGED_SYMBOL='↘'
    GIT_UNTRACKED_SYMBOL='?'

    # Solarized colorscheme
    FG_BASE03="%F{8}"
    FG_BASE02="%F{0}"
    FG_BASE01="%F{10}"
    FG_BASE00="%F{11}"
    FG_BASE0="%F{12}"
    FG_BASE1="%F{14}"
    FG_BASE2="%F{7}"
    FG_BASE3="%F{15}"

    BG_BASE03="%K{8}"
    BG_BASE02="%K{0}"
    BG_BASE01="%K{10}"
    BG_BASE00="%K{11}"
    BG_BASE0="%K{12}"
    BG_BASE1="%K{14}"
    BG_BASE2="%K{7}"
    BG_BASE3="%K{15}"

    FG_YELLOW="%F{3}"
    FG_ORANGE="%F{9}"
    FG_RED="%F{1}"
    FG_MAGENTA="%F{5}"
    FG_VIOLET="%F{13}"
    FG_BLUE="%F{4}"
    FG_CYAN="%F{6}"
    FG_GREEN="%F{2}"

    BG_YELLOW="%K{3}"
    BG_ORANGE="%K{9}"
    BG_RED="%K{1}"
    BG_MAGENTA="%K{5}"
    BG_VIOLET="%K{13}"
    BG_BLUE="%K{4}"
    BG_CYAN="%K{6}"
    BG_GREEN="%K{2}"

    RESET="%f%k"

    # what OS?
    case "$(uname)" in
        Darwin)
            PS_SYMBOL=$PS_SYMBOL_DARWIN
            ;;
        Linux)
            PS_SYMBOL=$PS_SYMBOL_LINUX
            ;;
        *)
            PS_SYMBOL=$PS_SYMBOL_OTHER
    esac

    __git_info() {
        # [ -x "$(/usr/bin/which git)" ] || return    # git not found

        # local git_eng="env LANG=C git"   # force git output in English to make our work easier
        local git_eng="git"
        # get current branch name or short SHA1 hash for detached head
        local branch="$($git_eng symbolic-ref --short HEAD 2>/dev/null || $git_eng describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return  # git branch not found

        local marks

        # branch is modified?
        # [ -n "$($git_eng status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"

        # how many commits local branch is ahead/behind of remote?
        local git_status="$($git_eng status --porcelain --branch)"
        # local stat="$(echo $git_status | grep '^##' | grep -o '\[.\+\]$')"
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
        set +x
        # local status_counts
        local status_counts="$GIT_STAGED_SYMBOL$stagedN $GIT_UNSTAGED_SYMBOL$unstagedN $GIT_UNTRACKED_SYMBOL$untrackedN"
        # [ $stagedN -gt 0 ] && status_counts+=" $GIT_STAGED_SYMBOL$stagedN"
        # [ $unstagedN -gt 0 ] && status_counts+=" $GIT_UNSTAGED_SYMBOL$unstagedN"
        # [ $untrackedN -gt 0 ] && status_counts+=" $GIT_UNTRACKED_SYMBOL$untrackedN"

        # get repo name
        local repo_name="$(basename "`git rev-parse --show-toplevel`")"

        # print the git branch segment without a trailing newline
        printf " $repo_name $GIT_BRANCH_SYMBOL$branch$marks [$status_counts] "
    }

    # https://github.com/riobard/bash-powerline/pull/11/files
    __rvm() {
        if [ -z "${RUBY_VERSION}" ] ; then
            return
        else
            printf " ${RUBY_VERSION/ruby-/r} "
        fi
    }

    __nvm() {
        if [ -d "$NVM_DIR" ] ; then
            local nvm_version=$(nvm_version)
            printf " n${nvm_version/v/} "
        else
            return
        fi
    }


    __venv() {
        if [[ -n "$VIRTUAL_ENV" ]]; then
            printf " py:${VIRTUAL_ENV##*/} "
        else
            return
        fi
    }

    setopt PROMPT_SUBST
    [[ $cmdcount -ge 1 ]] || cmdcount=1
    preexec() { ((cmdcount++)) }

    __num() {
        printf '$cmdcount'
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly.
        if [ $? -eq 0 ]; then
            local BG_EXIT="$BG_GREEN"
        else
            local BG_EXIT="$BG_RED"
        fi

        local pwd_check="$(pwd)"
        if [[ $pwd_check == *".git"* ]]; then
            local PS1_WD="%~"
            local GITINFO=""
        else
            local GIT_INFO="$(__git_info)"
            if [ -n "$GIT_INFO" ]; then
                local gitdir_check="$(git rev-parse --show-toplevel)"
                if [[ "$gitdir_check" = "$pwd_check" ]]; then
                    local PS1_WD="-->"
                else
                    local PS1_WD=${pwd_check/"${gitdir_check}\/"/""}
                fi
            else
                local PS1_WD="%~"
            fi
        fi

        PS1="$BG_CYAN$FG_BASE3 %* $RESET"
        # PS1+="$BG_BASE3$FG_BASE02 %n : $(__num) $RESET"
        PS1+="$BG_BASE3$FG_BASE02 $(__num) $RESET"
        PS1+="$BG_ORANGE$FG_BASE3$(__rvm)$RESET"
        PS1+="$BG_GREEN$FG_BASE02$(__nvm)$RESET"
        PS1+="$BG_BASE3$FG_BASE02$(__venv)$RESET"
        PS1+="$BG_BLUE$FG_BASE3$GIT_INFO$RESET"
        PS1+=$'\n'
        PS1+="$BG_BASE03$FG_BASE3 $PS1_WD $RESET"
        PS1+="$BG_EXIT$FG_BASE3 $PS_SYMBOL $RESET "
    }

    precmd() { ps1 }
}

__powerline
unset __powerline
