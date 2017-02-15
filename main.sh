#
declare -x BASHU="$HOME/bashu"
declare -x DROPBOX="$HOME/Dropbox"
declare -x DROPBOX_SHELL="$DROPBOX/mac-shell"
declare -x SCRIPTS="$DROPBOX_SHELL/scripts"

# PATH
declare -x PATH="/bin:/sbin:/usr/bin:/usr/sbin" # base path
declare -x PATH="$PATH:$SCRIPTS" # scripts
declare -x PATH="$PATH:/Applications" # mac apps folder
declare -x PATH="$PATH:node_modules/.bin" # local node bin folders

alias bashu="pushd $BASHU"
source $BASHU/brew.sh
source $BASHU/dev.sh
source $BASHU/osx.sh
source $BASHU/git.sh
source $SCRIPTS/private.sh

# bash
alias cd..="cd .."
alias ls="ls -alFG"
alias ll=ls
alias pd="pushd"
alias ps="ps -Ajww"
alias grep="grep --color=auto"
alias egrep='egrep --color=auto'

alias path="ruby -e \"ENV['PATH'].split(':').each{|x|puts x}\""
alias hist="history | grep -i"
export HISTTIMEFORMAT="%b %d %I:%M:%S %p "
export HISTFILESIZE=5000
export HISTSIZE=5000
alias psg="ps -Ajww | grep -v grep | egrep -i"
alias vpnreset="sudo killall -INT -u root vpnagentd; sudo SystemStarter start vpnagentd"
alias resource="source $BASHU/main.sh"

# editors
alias subl='"/Applications/Sublime Text 2.app/Contents/SharedSupport/bin/subl"'
alias sub='subl -n; subl -a'
alias sp='cd $DROPBOX/Sublime\ Projects/'
alias nano='nano -c'
declare -x EDITOR=/usr/local/bin/nano
alias editprofile="sub --wait --project $DROPBOX/Sublime\ Projects/bashu.sublime-project $BASHU/main.sh; resource"

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

