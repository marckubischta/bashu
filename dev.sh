# adb
declare -x ANDROID_HOME="$HOME/Library/Android/sdk"
declare -x PATH="$PATH:$ANDROID_HOME/build-tools/29.0.0"
declare -x PATH="$PATH:$ANDROID_HOME/emulator"
declare -x PATH="$PATH:$ANDROID_HOME/platform-tools"
declare -x PATH="$PATH:$ANDROID_HOME/tools"

# python
declare -x PATH="/usr/local/opt/python\@3.8/bin:$PATH"
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

# test -f ~/.nvm/nvm.sh && source ~/.nvm/nvm.sh && nvm use default
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Adobe
alias comments="pd /git/ccx-comments > /dev/null"
alias root="pd /git/ccx-sharing > /dev/null"
alias ssc="pd /git/ccx-sharing/packages/component-react > /dev/null"
alias sswp="pd /git/ccx-sharing/packages/ccx-share-sheet-web-page > /dev/null"

yarn_alias_wrap() {
  echo 🧵 $*
  $*
}

sh_alias_wrap() {
  if [[ "$NODE_ENV" != "" ]]; then
    echo 🐚 NODE_ENV=$NODE_ENV $*
    $*
  else
    echo 🐚 $*
    $*
  fi
}

alias yw="yarn_alias_wrap 'yarn workspace @ccx-public/share-sheet-web-page'"
alias yc="yarn_alias_wrap 'yarn workspace @ccx-public/ccx-share-sheet'"

declare -x DUMP_MOCKS=1

# sharesheet

alias localhost="open https://localhost.adobe.com:80/?env=stage\&mode=dev\&api=V4\&fetch=cloud\&groups=true\&reshare=true\&defaultRole=none"
alias cep="sswp; rm -rf cep; sh_alias_wrap 'node ./bin/cli.js make -pl cep -pd IDSN'"
alias uxp="sswp; rm -rf uxp; NODE_ENV=development sh_alias_wrap 'webpack --mode development --config webpack/uxp/webpack.config.js'"
alias build-xd="sswp; rm -rf build; sh_alias_wrap 'node ./bin/cli.js make -pl web -pd XD'"

nw() {
  if echo $* | grep -q ^fragile\.; then
    CMD=`echo $* | sed -Ee "s/fragile\.([^\.]*)\.(.*)/nightwatch --test nightwatch\/tests-fragile\/\1.js --testcase \"\2\"/"`
  else
    CMD=`echo $* | sed -Ee "s/([^\.]*)\.(.*)/nightwatch --test nightwatch\/tests\/\1.js --testcase \"\2\"/"`
  fi
  echo 👻 $CMD
  bash -c "$CMD"
}

nwcheck() {
  ssc
  errors=""
  while read testcase
    do nw $testcase
    if [[ "$?" != "0" ]]; then
      errors="$errors\n${testcase}"
    fi
  done <<< "$(cat nw.txt)"
  if [[ "$errors" != "" ]]; then
    echo -e "🚨 Failed testcases: $errors"
    return 1
  fi
}

stop() {
  lsop $1 kill $*
}

alias start='root; sh_alias_wrap "releng/ci_start.sh @ccx-public/ccx-share-sheet"; ssc'
alias start-wp='root; sh_alias_wrap "releng/ci_start.sh @ccx-public/share-sheet-web-page"; sswp'
alias lb='root; stop 80; sh_alias_wrap "lerna clean"; sh_alias_wrap "lerna bootstrap"'
