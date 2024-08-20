BREW_ROOT=/opt/homebrew
test -d $BREW_ROOT && PATH=$BREW_ROOT/bin:$BREW_ROOT/sbin:$PATH
test -x $BREW_ROOT/bin/ruby && PATH=`ruby -e 'print Gem.default_bindir'`:$PATH
