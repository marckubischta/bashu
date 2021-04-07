# zsh?
chsh -s /bin/bash

# bootstrap
test "$DROPBOX_SHELL" != "" || source ~/bashu/main.sh
grep "source.*bashu/main\.sh" ~/.profile > /dev/null || echo "source $HOME/bashu/main.sh" >> $HOME/.profile

# nano config
test -e $HOME/.nanorc || ln -hsv $DROPBOX_SHELL/nano/nanorc $HOME/.nanorc

# iterm2 integration
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# install brew formulae
brew tap homebrew/dupes
# ruby? gettext go ruby ruby193 libyaml ncurses oniguruma openssl pkg-config jq jsonpp fpp
export BASHU_BREW_FORMULAE="readline ack git nano tig mitmproxy"
echo $BASHU_BREW_FORMULAE| xargs -n 1 -I FORMULA bash -c "brew list | grep FORMULA > /dev/null || brew info FORMULA" 

