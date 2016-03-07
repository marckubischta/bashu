#
declare -x DROPBOX="$HOME/Dropbox"
declare -x DROPBOX_SHELL="$DROPBOX/mac-shell"

# PATH
declare -x PATH="/bin:/sbin:/usr/bin:/usr/sbin" # base path
declare -x PATH="$PATH:$DROPBOX_SHELL/scripts" # scripts
declare -x PATH="$PATH:/Applications" # mac apps folder

alias bashu="pushd ~/bashu"
source ~/bashu/brew.sh
source ~/bashu/dev.sh
source ~/bashu/osx.sh
source ~/bashu/git.sh
source $DROPBOX_SHELL/scripts/private.sh

# bash
alias cd..="cd .."
alias ls="ls -alFG"
alias ll=ls
alias pd="pushd"
alias ps="ps -Ajww"
alias grep="grep --color=auto"
alias egrep='egrep --color=auto'

alias nano='nano -c'
alias bb='bbedit'
alias path="ruby -e \"ENV['PATH'].split(':').each{|x|puts x}\""
alias hist="history | grep -i"
export HISTTIMEFORMAT="%b %d %I:%M %p "
export HISTFILESIZE=5000
export HISTSIZE=5000
alias psg="ps -Ajww | grep -v grep | egrep -i"

declare -x SHELL_PROFILE=$DROPBOX_SHELL/bash_profile.txt
alias reloadprofile="source $SHELL_PROFILE"
alias editprofile="nano -Y sh $SHELL_PROFILE; reloadprofile"

alias vpnreset="sudo killall -INT -u root vpnagentd; sudo SystemStarter start vpnagentd"
declare -x EDITOR=/usr/local/bin/nano


epoch() {
  ruby -e 'puts Time.now.to_i'
  node -e "console.log(new Date($1))"
}
alias epochlist="ruby -e \"require 'time';i = Time.now.to_i.to_f;(0..7).each {|q|q=10**q;f=i-i%q+q;puts\\\"#{f.to_i} => #{Time.at(f)}\\\"}\""


# iterm2
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

function iterm2_print_user_vars() {
  iterm2_set_user_var gitBranch $((git branch 2> /dev/null) | grep \* | cut -c3-)
}
