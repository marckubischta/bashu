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

test -f ~/.nvm/nvm.sh && source ~/.nvm/nvm.sh && nvm use stable
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm


# Adobe
alias userlogs="pd ~/Library/Logs"
alias synclogs="pd ~/Library/Application\ Support/Adobe/CoreSync"
alias f5dev="f5-developer --tou"
alias ccweb="pd /git/ccweb"
alias gnav="pd /git/globalnav"
alias qe="pd /git/qe"

# CCWeb
declare -x PATH="$PATH:/git/ccweb/node_modules/.bin" # ccweb
alias mocas="PHANTOMJS_EXECUTABLE=node_modules/.bin/phantomjs node_modules/.bin/mocha-casperjs --casper-timeout=360000 --timeout=360000 --slow=10000 --viewport-width=900 --viewport-height=900 --ssl-protocol=tlsv1"
casperd() {
  ASSETS_SUITE="$1" ASSETS_RETRIES=0 ASSETS_VERBOSE=1 ASSETS_DEBUG=0 npm run-script test-ui
}
caspers() {
  ASSETS_SUITE="$1" ASSETS_RETRIES=0 npm run-script test-ui
}
casperx() {
  ASSETS_SUITE="$1" ASSETS_XML_OUTPUT=1 ASSETS_VERBOSE=1 npm run-script test-ui
}
alias PROD="ASSETS_ENDPOINT=https://assets.adobe.com"
alias STAGE="ASSETS_FEATURE_SET=7yc6uiq0xw"

auth() {
 ~/scripts/auth.rb $* > ~/auth.sh
 source ~/auth.sh
}
alias carl="curl -H \"\$AUTH\""