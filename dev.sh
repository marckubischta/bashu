# adb
declare -x ANDROID_HOME="$HOME/Library/Android/sdk"
declare -x PATH="$PATH:$ANDROID_HOME/build-tools/29.0.0"
declare -x PATH="$PATH:$ANDROID_HOME/emulator"
declare -x PATH="$PATH:$ANDROID_HOME/platform-tools"
declare -x PATH="$PATH:$ANDROID_HOME/tools"

# python
declare -x PATH="/usr/local/opt/python/libexec/bin:$PATH"
alias python2='PATH=/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin python'

# JAVA
declare -x JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_66.jdk/Contents/Home"

# cmake
declare -x CMAKE_HOME="/Applications/CMake.app/Contents/bin"
declare -x PATH="$PATH:$CMAKE_HOME"


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

iwt() {
  wds-stop-all
  npm run linter &
  npm ci
  npm run test &
  bin/ci_start.sh --hot
}

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

wds-stop-all() {
  if [[ `ps -A | grep 'webpack-dev-server' | grep -v grep` ]]; then
    echo `ps -A -o pid -o command | grep -v grep | grep 'webpack-dev-server'`
    ps -A -o pid -o command |
      grep -v grep |
      grep 'webpack-dev-server' |
      awk '{print $1}' |
      xargs -I PID -t sudo kill PID;
  fi;
}

alias wds-restart="wds-stop-all && npm ci && bin/ci_start.sh --hot"
alias iw="wds-restart"

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