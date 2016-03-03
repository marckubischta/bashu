# bootstrap
test "$DROPBOX_SHELL" != "" || source ~/bashu/main.sh
grep "source.*bashu/main\.sh" ~/.profile > /dev/null || echo "source $HOME/bashu/main.sh" >> $HOME/.profile

# nano config
test -e $HOME/.nanorc || ln -hsv $DROPBOX_SHELL/nano/nanorc $HOME/.nanorc

# install brew formulae
brew tap homebrew/dupes
# ruby? gettext go ruby ruby193 libyaml ncurses oniguruma openssl pkg-config
export BASHU_BREW_FORMULAE="readline ack fpp git jq jsonpp nano tig"
echo $BASHU_BREW_FORMULAE| xargs -n 1 -I FORMULA bash -c "brew list | grep FORMULA > /dev/null || brew info FORMULA" 

