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
declare -x JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_321.jdk/Contents/Home"
declare -x PATH="$PATH:$JAVA_HOME/bin"

# cmake
declare -x CMAKE_HOME="/Applications/CMake.app/Contents/bin"
declare -x PATH="$PATH:$CMAKE_HOME"

# JSON
alias json="python -mjson.tool"
scripts() {
  if [[ "$1" == "" ]]; then
    sh_alias_wrap "jq .scripts package.json"
  else
    sh_alias_wrap "jq .scripts $1/package.json"
  fi
}

# node
declare -x NODE_PATH="/usr/local/lib/node_modules"

# test -f ~/.nvm/nvm.sh && source ~/.nvm/nvm.sh && nvm use default
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Adobe
alias pac="pd packages > /dev/null"
alias comments="pd /git/ccx-comments > /dev/null"
alias ss="pd /git/ccx-sharing > /dev/null"
alias ssc="pd /git/ccx-sharing/packages/component-react > /dev/null"
alias sscw="pd /git/ccx-sharing/packages/component-web > /dev/null"
alias sswp="pd /git/ccx-sharing/packages/ccx-share-sheet-web-page > /dev/null"

alias core="pd /git/component-core > /dev/null"
alias harness="pd /git/component-core/packages/component-harness > /dev/null"
alias resetnodecaches="sh_alias_wrap 'npm cache clean --force' && sh_alias_wrap 'yarn cache clean'"

# playwright
# - there's a bug in show-trace preventing it from working on paths with spaces
alias pw="../../bin/playwright.sh"
alias ptrace="sh_alias_wrap 'npx playwright show-trace'"
alias report="sh_alias_wrap 'npx playwright show-report artifacts/playwright-report'"

yarn_alias_wrap() {
  echo 🧵 $*
  $*
}

sh_alias_wrap() {
  if [[ "$NODE_ENV" != "" ]]; then
    echo 🐚 NODE_ENV=$NODE_ENV $*
    $*
  elif [[ "$TEST_PORT" != "" ]]; then
    echo 🐚 TEST_PORT=$TEST_PORT $*
    $*
  else
    echo 🐚 $*
    $*
  fi
}

sh_alias_wrap_q() {
  cmd=$1
  shift
  echo 🐚 $cmd "$*"
  $cmd "$*"
}

alias yw="yarn_alias_wrap 'yarn workspace @ccx-public/share-sheet-web-page'"
alias yc="yarn_alias_wrap 'yarn workspace @ccx-public/ccx-share-sheet'"

declare -x DUMP_MOCKS=1

# sharesheet

alias localhost="open https://localhost.adobe.com:80/?env=stage\&mode=dev\&api=V4\&groups=true"
alias build-xd="sswp; rm -rf build; sh_alias_wrap 'node ./bin/cli.js make -pl web -pd XD'"
alias cep="sswp; rm -rf cep; sh_alias_wrap 'node ./bin/cli.js make -pl cep -pd IDSN'"
alias rs2="sscw; stop 443; INCLUDE_RS2=true EXCLUDE_SWC=true lerna run build; yarn start &"
alias swc="sscw; stop 443; INCLUDE_RS2=false EXCLUDE_SWC=false lerna run build; yarn start &"
alias uxp="sswp; rm -rf uxp; NODE_ENV=development sh_alias_wrap 'webpack --mode development --config webpack/uxp/webpack.config.js'"

ow() {
  if echo $* | grep -q ^swc\.; then
    CMD=`echo $* | sed -Ee "s/fragile\.([^\.]*)\.(.*)/nightwatch --test nightwatch\/tests-fragile\/\1.js --testcase \"\2\"/"`
  else
    CMD=`echo $* | sed -Ee "s:([^\.]*\.spec\.ts)(\.|[\:0-9]+)(.*):..\/..\/bin\/playwright.sh playwright\/tests\/\1 -g \"\3\":" | sed -Er "s: › :.*:g"`
  fi
  echo 👻 $CMD
  bash -c "$CMD"
}

owc() {
  if echo $* | grep -q ^swc\.; then
    CMD=`echo $* | sed -Ee "s/fragile\.([^\.]*)\.(.*)/nightwatch --test nightwatch\/tests-fragile\/\1.js --testcase \"\2\"/"`
  else
    CMD=`echo $* | sed -Ee "s:([^\.]*\.spec\.ts)(\.|[\:0-9]+)(.*):..\/..\/bin\/playwright.sh --swc playwright\/tests\/\1 -g \"\3\":" | sed -Er "s: › :.*:g"`
  fi
  echo 👻 $CMD
  bash -c "$CMD"
}

pwcheck() {
  ssc
  errors=""
  while read testcase
    do ow $testcase
    if [[ "$?" != "0" ]]; then
      errors="$errors\n${testcase}"
    fi
  done <<< "$(cat pw.txt)"
  if [[ "$errors" != "" ]]; then
    echo -e "🚨 Failed testcases: $errors"
    return 1
  fi
}

stop() {
  sh_alias_wrap "lsop $1 kill"
}

alias nl='sh_alias_wrap "nvm list"'
alias nu='sh_alias_wrap "nvm use"'
alias start='ss; sh_alias_wrap "bin/webapp.sh"; ssc'
alias start-cdn='ss; TEST_PORT=443 sh_alias_wrap "releng/ci_yarn_launch.sh @ccx-public/cc-share-sheet-web start"; sscw'
alias loader=start-cdn
alias start-swc='ss; sh_alias_wrap "bin/webapp.sh -dsp 8080"; ssc'
alias start-swc-undefined='ss; sh_alias_wrap "bin/webapp.sh -sp 8080"; ssc'
alias start-wrapper='ss; sh_alias_wrap "releng/ci_start.sh @ccx-public/share-sheet-web-page"; sswp'
alias lb='sh_alias_wrap "lerna clean"; sh_alias_wrap "lerna bootstrap"'
alias corelb='core; sh_alias_wrap "lerna clean --ci"; sh_alias_wrap "lerna bootstrap" && sh_alias_wrap "lerna run build"'
root() {
  while pwd | grep -q packages; do cd ..; done
}
pkg() {
  root
  cd packages/$*
}
_pkg_completion() {
  # input commandline passed via COMP_WORDS / COMP_CWORD
  local WORD="${COMP_WORDS[COMP_CWORD]}"

  # look up-tree for the folder that packages live in
  local WKD=$(pwd | sed -Ee "s:(.*)/packages.*:\1:")

  # set output options in COMPREPLY
  COMPREPLY=( $(/bin/ls -1 "$WKD/packages" | grep "$WORD") )
} &&

complete -F _pkg_completion pkg
# -F function: run the function (1) for the command (2)



# copy the uxp sharesheet folder into the specified PS .app and launch it

ups() {
  if [[ -d uxp ]]; then
    APP_SS="$1/Contents/Required/UXP"
    if [[ -e "$APP_SS" ]]; then
      rm -rf "$APP_SS/com.adobe.ccx.sharesheet"
      cp -R uxp/com.adobe.ccx.sharesheet "$APP_SS/com.adobe.ccx.sharesheet"
      open "$1"
    else
      echo no ss found in $APP_SS
    fi
  else
    echo no local uxp build found
  fi;
}
