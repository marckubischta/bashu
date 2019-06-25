# adb
declare -x ANDROID_HOME="$HOME/Library/Android/sdk"
declare -x PATH="$PATH:$ANDROID_HOME/platform-tools"
declare -x PATH="$PATH:$ANDROID_HOME/tools"

# GO
export GOPATH=$HOME/go
declare -x PATH="$PATH:$GOPATH/bin:/usr/local/opt/go/libexec/bin" # golang exe

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

wrapper-test() {
  set -e
  # run this from inside your share-sheet-web-page repo root
  # pass in the following args:
  # $1 - github component fork (org/user) name (not remote name)
  # $2 - github component PR branch
  WRAP_TEST_FORK=$1
  WRAP_TEST_BRANCH=$2

  START_DIR=`pwd`

  # build everything
  echo === Building wrapper dependencies from package-lock
  npm ci || (echo "=== npm ci failed. Is your lock file up to date?" && return 2)
  # remove the artifactory sharesheet component
  echo === Removing node_modules ccx-share-sheet
  npm uninstall @ccx/ccx-share-sheet
  # install the component from the PR branch to get its dependencies installed
  echo === Installing dependencies for ccx-share-sheet from PR branch ${WRAP_TEST_FORK}:${WRAP_TEST_BRANCH}
  npm install --save "git+ssh://git@git.corp.adobe.com:${WRAP_TEST_FORK}/ccx-share-sheet#${WRAP_TEST_BRANCH}" || (echo === Git branch not found: ${WRAP_TEST_FORK}/ccx-share-sheet#${WRAP_TEST_BRANCH} && return 3)

  # remove the sharesheet component module which has no dist folder
  rm -r node_modules/@ccx/ccx-share-sheet

  # wrap this in a method since we are changing dirs and want to be able to cancel cleanly
  [ -d node_modules/@ccx ] || (echo === ./node_modules/@ccx not found, aborting && return 4)
  cd node_modules/@ccx/
  buildComponent() {    
    set -e
    # clone the sharesheet component PR source repo so we can build its dist folder
    echo === Pulling to node_modules ${WRAP_TEST_FORK}/ccx-share-sheet PR branch ${WRAP_TEST_BRANCH} 
    git clone "git@git.corp.adobe.com:${WRAP_TEST_FORK}/ccx-share-sheet" || (echo === Git clone failed && return 5)
    [ -d ccx-share-sheet ] || (echo === ./node_modules/@ccx/ccx-share-sheet not found, aborting && return 6)
    cd ccx-share-sheet
    buildComponentPostPull() {
      set -e

    # pull and checkout the PR branch
      git fetch --tags --progress "git@git.corp.adobe.com:${WRAP_TEST_FORK}/ccx-share-sheet" +refs/pull/*:refs/remotes/origin/pr/*
      git branch -r | grep ${WRAP_TEST_BRANCH}
      git fetch origin "${WRAP_TEST_BRANCH}"
      git checkout "${WRAP_TEST_BRANCH}"

    # build node modules and dist folder
      echo === Building PR branch ccx-share-sheet#${WRAP_TEST_BRANCH} from its package-lock
      cp ../../../.npmrc .
      npm ci || (echo "=== npm ci failed in component, aborting" && return 7)
      npm run build

    # perform the build step that updates the index.js to point to dist
      sed -i'.original' 's/src/dist/g' index.js

    # clean up
      rm -r node_modules
      rm -r src
    }
    buildComponentPostPull
  }
  buildComponent
  # back to wrapper repo
  cd $START_DIR

  # run and zip the wrapper build
  echo === Building wrapper using PR branch component
  npm run build-production
  zip -r build.zip build -x *.js.map *.DS_Store
  echo === Build with ${WRAP_TEST_FORK}:${WRAP_TEST_BRANCH} is in ./build/ and ./build.zip
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