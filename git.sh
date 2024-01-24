
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
  git_alias_wrap "git push $USER :$1"; git_alias_wrap "git branch -D $1"
}
alias unb=unbranch

git_alias_wrap() {
  echo 🐙 $*
  $*
}

git_alias_wrap_q() {
  cmd=$1
  shift
  echo 🐙 $cmd "$*"
  $cmd "$*"
}

alias gg="git_alias_wrap 'git status'"
alias gl="git_alias_wrap 'git log --pretty=oneline'"
alias gr="git_alias_wrap 'git remote -v' && git_alias_wrap 'git branch --all --verbose'"
alias gd="git_alias_wrap 'git diff'"
alias gb="git_alias_wrap 'git branch'"
alias gk="git_alias_wrap 'git checkout --'"
alias gkm="git_alias_wrap 'git checkout main' || git_alias_wrap 'git checkout master'"
alias gfo="git_alias_wrap 'git fetch origin'"
alias gkl="gkm && gfo && git_alias_wrap 'git rebase origin/main' || git_alias_wrap 'git rebase origin/master'"
alias gcb="git_alias_wrap 'git checkout -b'"
alias gcmt="git_alias_wrap_q 'git commit -m'"
alias gcm="git_alias_wrap_q 'git commit --no-verify -m'"
alias gcam="git_alias_wrap_q 'git commit --no-verify --all -m'"
alias gsu="git_alias_wrap 'git submodule update --init --recursive'"
alias ignore="git_alias_wrap 'git update-index --assume-unchanged'"

gitpr() {
  gkm && git branch | grep -q PR_$1 && git_alias_wrap "git branch -D PR_$1"
  git_alias_wrap "git fetch origin refs/pull/$1/head:PR_$1" && git_alias_wrap "git checkout PR_$1"
}

hotswappr() {
  lsop 80 kill -9
  lsop 80
  if [ "$1" != "" ]; then
    gitpr $1
  fi
  sudo rm -rf ./node_modules
  npm ci
  bin/ci_start.sh
}

git_new_pr() {
  declare HOST=`git remote -v | grep origin | grep push | sed s/[\@\:]/\ /g | awk '{ print $3 }'`
  declare BRANCH=`git branch | grep "*" | awk '{ print $2 }'`
  declare ORIGIN=`git remote -v | grep origin | grep fetch | sed s/[\:.]/\ /g | awk '{ print $6 }'`
  open https://$HOST/$ORIGIN/compare/main...$USER:$BRANCH?expand=1
}

function iterm2_print_user_vars() {
  iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
}

function _pre_git_prompt
{
  local BGBLACK="\[\e[40m\]"
  local BLACK="\[\e[30m\]"
  local RED="\[\e[31m\]"
  local GREEN="\[\e[32m\]"
  local YELLOW="\[\e[33m\]"
  local BLUE="\[\e[34m\]"
  local PURPLE="\[\e[35m\]"
  local GRAY="\[\e[37m\]"
  local BOLD="\[\e[1m\]"
  local NORM="\[\e[0m\]"
  case $TERM in
    xterm*)
      local TITLEBAR="\[\e]0;\$LABEL \W\a\]"
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
  echo -n "${TITLEBAR}${BGBLACK}\h:\W${NORM}"
}

function _save_result_command {
  export _SAVED_COMMAND_RESULT="$?"
}

# hanafuda
flower=""
case `date "+%m"` in
  (01) flower="🎍";; # Pine / Crane / Sun
  (02) flower="🌺";; # Plum Blossom / Bush Warbler
  (03) flower="🌸";; # Cherry Blossom / Curtain
  (04) flower="🍇";; # Wisteria / Cuckoo
  (05) flower="🌷";; # Iris / Bridge
  (06) flower="🦋";; # Peony / Butterflies
  (07) flower="🍀";; # Bush Clover / Boar
  (08) flower="🌾";; # Susuki Grass / Geese
  (09) flower="🍵";; # Chrysanthemum / Sake cup
  (10) flower="🍁";; # Maple / Deer
  (11) flower="⚡️";; # Willow / Lightning
  (12) flower="⭐️";; # Paulownia / Phoenix
esac

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
  if [ "$_SAVED_COMMAND_RESULT" == "0" ]; then
    echo -n "$flower "
  else
    echo -n "${_SAVED_COMMAND_RESULT}🎋 "
  fi
}

function iterm2_generate_ps1
{
  _save_result_command && history -a && __git_ps1 "`_pre_git_prompt`" " `_post_git_prompt`"
}

PROMPT_COMMAND='_save_result_command && history -a && __git_ps1 "`_pre_git_prompt`" " `_post_git_prompt`"'
