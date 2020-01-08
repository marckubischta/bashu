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

# node
declare -x NODE_PATH="/usr/local/lib/node_modules"

test -f ~/.nvm/nvm.sh && source ~/.nvm/nvm.sh && nvm use stable
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


# Adobe
alias comments="pd /git/ccx-comments"
alias cwp="pd /git/ccx-comments-web-page"
alias ssc="pd /git/ccx-share-sheet"
alias sswp="pd /git/ccx-share-sheet-web-page"

# sharesheet

nw() {
  CMD=`echo $* | sed -Ee "s/([^\.]*)\.(.*)/nightwatch --test nightwatch\/tests\/\1.js --testcase \"\2\"/"`
  echo $CMD
  bash -c "$CMD"
}

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

stop() {
  lsop $1 kill $*
}

alias start='bin/ci_start.sh'
alias ci='sudo rm -rf node_modules/.cache; npm ci'
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