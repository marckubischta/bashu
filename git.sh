
# git completion / shell status
# from https://github.com/git/git/tree/master/contrib/completion
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
alias gr="git remote -v && git branch --all --verbose"
alias gd="git diff"
alias gb="git branch"
alias gk="git checkout --"
alias gry="gk yarn.lock && git checkout master && git fetch origin && git rebase origin/master"

git_new_pr() {
  declare HOST=`git remote -v | grep origin | grep push | sed s/[\@\:]/\ /g | awk '{ print $3 }'`
  declare BRANCH=`git branch | grep "*" | awk '{ print $2 }'`
  declare ORIGIN=`git remote -v | grep origin | grep fetch | sed s/[\:.]/\ /g | awk '{ print $6 }'`
  open https://$HOST/$ORIGIN/compare/master...$USER:$BRANCH?expand=1
}

function iterm2_print_user_vars() {
  iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
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
  local PROMPTDATE="\t"
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
#  echo -n "${TITLEBAR}${BLUE}${PROMPTDATE}${NORM}"
  echo -n "${TITLEBAR}${PURPLE}\w${NORM}"
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
#  echo -n "${PURPLE}\w${BLACK}${BOLD}\$${NORM} "
  echo -n "${BLACK}${BOLD}\$${NORM} "
}
PROMPT_COMMAND='history -a && iterm2_prompt_mark && __git_ps1 "`_pre_git_prompt`" " `_post_git_prompt`"'
