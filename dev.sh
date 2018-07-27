# adb
declare -x PATH="$PATH:/Applications/android-sdk-macosx/platform-tools"

# GO
export GOPATH=$HOME/go
declare -x PATH="$PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin" # golang exe

# JSON
alias json="python -mjson.tool"

# ruby
declare -x PATH="/usr/local/opt/ruby193/bin:/usr/local/opt/ruby/bin:${PATH}" # prefer brew-managed ruby installs over native install in /usr/bin
export PATH=/usr/local/Cellar/ruby193/1.9.3-p547/bin:$PATH #explicit path to brew ruby 193... not sure if this is needed
declare -x RUBYLIB=lib

# docker
declare -x PATH="$PATH:$HOME/adobe/bin" # local docker install
denv() {
 eval "$(docker-machine env $1)"
}

# node
declare -x NODE_PATH="/usr/local/lib/node_modules"

alias yarn="yarn --ignore-engines"
alias yarnit="yarn install && yarn test"
alias npm_clean_rebuild="npm cache clean && rm -rf node_modules && npm install"

test -f ~/.nvm/nvm.sh && source ~/.nvm/nvm.sh && nvm use stable
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


# Adobe
alias userlogs="pd ~/Library/Logs"
alias synclogs="pd ~/Library/Application\ Support/Adobe/CoreSync"
alias ccr="nvm use v6.10 && pd /git/ccx-comments"
alias cct="nvm use v6.10 && pd /git/ccx-comments-torq"
alias ssr="nvm use v6.10 && pd /git/ccx-share-sheet"
alias sst="nvm use v6.10 && pd /git/ccx-share-sheet-torq"
alias ccx="nvm use v6.10 && pd /git/comments-example"

# sharesheet

#alias yww="if [[ \`ps -A | grep 'sudo yarn watch' | grep -v grep\` ]]; then ps -A -o pid -o command | grep -v grep | grep 'sudo yarn watch' | awk '{print \$1}' | xargs -I PID -t sudo kill PID; fi; sudo yarn watch --hot --disableHostCheck --host 0.0.0.0 0>&- 1>&- 2>&- &"

yw() {
  if [[ `ps -A | grep 'sudo yarn watch' | grep -v grep` ]]; then
    echo `ps -A -o pid -o command | grep -v grep | grep 'sudo yarn watch'`
    ps -A -o pid -o command |
      grep -v grep |
      grep 'sudo yarn watch' |
      awk '{print $1}' |
      xargs -I PID -t sudo kill PID;
  fi;
  echo 'sudo yarn watch --hot --disableHostCheck --host 0.0.0.0';
  sudo yarn watch --hot --disableHostCheck --host 0.0.0.0 0>&- 1>&- 2>&- &
}

adobeid() {
 ~/scripts/adobeid.rb $* > ~/adobeid.sh
 source ~/adobeid.sh
 echo $URNID
}

auth() {
 ~/scripts/auth.rb $* > ~/auth.sh
 source ~/auth.sh
}
alias carl="curl -H \"\$AUTH\""