
source $DROPBOX_SHELL/scripts/git-completion.bash
source $DROPBOX_SHELL/scripts/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto verbose name git"
export GIT_PS1_SHOWCOLORHINTS=1

alias gitdiffxcode="git config --global diff.external $DROPBOX_SHELL/git-diff-cmd.sh"
alias ungitdiffxcode="git config --global --unset diff.external"
alias gitcolor="git config --global color.ui auto"
unbranch() {
  git push $USER :$1 && git branch -d $1
}
gitpr() {
  git fetch origin refs/pull/$1/head:PR_$1 && git checkout PR_$1
}
gitprm() {
  git fetch $USER refs/pull/$1/head:PR_$1 && git checkout PR_$1
}
gitdown() {
  declare BRANCH=`git branch | grep "*" | awk '{ print $2 }'`
  git status; git fetch; git status; git stash; git rebase origin/$BRANCH;git stash pop
}
alias gg="git status"
alias gl="git log --pretty=oneline"
alias gr="git remote -v && git branch -a --list --verbose"
alias gd="git diff"
alias gb="git branch"
function _git_prompt() {
    local git_status="`git status -unormal 2>&1`"
    if ! [[ "$git_status" =~ Not\ a\ git\ repo ]]; then
        if [[ "$git_status" =~ nothing\ to\ commit ]]; then
            local ansi=32
        elif [[ "$git_status" =~ nothing\ added\ to\ commit\ but\ untracked\ files\ present ]]; then
            local ansi=33
        else
            local ansi=31
        fi
        if [[ "$git_status" =~ On\ branch\ ([^[:space:]]+) ]]; then
            branch=${BASH_REMATCH[1]}
            test "$branch" != master && branch="[$branch]" || branch=' ☆ '
        else
            # Detached HEAD.  (branch=HEAD is a faster alternative.)
            branch="(`git describe --all --contains --abbrev=4 HEAD 2> /dev/null ||
                echo HEAD`)"
        fi
        echo -n '\[\e[0;'"$ansi"';1m\]'"$branch"'\[\e[0m\] '
    fi
}
function _prompt_command() {
    PS1="`_git_prompt``marc_prompt`"
}

function _pre_git_prompt
{
  local BLACK="\[\e[30m\]"
  local RED="\[\e[31m\]"
  local GREEN="\[\e[32m\]"
  local YELLOW="\[\e[33m\]"
  local BLUE="\[\e[34m\]"
  local PURPLE="\[\e[35m\]"
  local GRAY="\[\e[37m\]"
  local BOLD="\[\e[1m\]"
  local NORM="\[\e[0m\]"
  local PROMPTDATE="\D{%m/%d} \t"
  case $TERM in
    xterm*)
      local TITLEDATE="\d \D{%Y}"
      local TITLEBAR="\[\e]0;\$LABEL \w\a\]"
      ;;
    *)
      local TITLEBAR=""
      ;;
  esac
  case $TMUX in
    # tmux window 0 only:
    /*0)
      local TITLEBAR="${GREEN} ${LABEL} "
      ;;
    *)
      ;;
  esac
  echo -n "${TITLEBAR}${BLUE}${PROMPTDATE}${NORM}"
}

function _post_git_prompt
{
  local BLACK="\[\e[30m\]"
  local RED="\[\e[31m\]"
  local GREEN="\[\e[32m\]"
  local YELLOW="\[\e[33m\]"
  local BLUE="\[\e[34m\]"
  local PURPLE="\[\e[35m\]"
  local GRAY="\[\e[37m\]"
  local BOLD="\[\e[1m\]"
  local NORM="\[\e[0m\]"
  local PROMPTDATE="\D{%m/%d} \t"
  echo -n "${PURPLE}\w${BLACK}${BOLD}\$${NORM} "
}
PROMPT_COMMAND='__git_ps1 "`_pre_git_prompt`" " `_post_git_prompt`"'
