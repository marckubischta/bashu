declare -x BASH_SILENCE_DEPRECATION_WARNING=1

# osx finder
alias showall="defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder"
alias unshowall="defaults write com.apple.finder AppleShowAllFiles FALSE; killall Finder"

alias dq="xattr -d com.apple.quarantine"

alias dockdimhide="defaults write com.apple.Dock showhidden -boolean yes; killall Dock"
alias dockinstahide="defaults write com.apple.Dock autohide-delay -float 0.05; defaults write com.apple.dock autohide-time-modifier -float 0.05; killall Dock"

alias ccscreenshots="defaults write com.apple.screencapture location ~/Creative\ Cloud\ Files/Screenshots/;killall SystemUIServer"
alias screenshots="defaults write com.apple.screencapture location ~/Screenshots/;killall SystemUIServer"

alias flushdns="test \"`which dscacheutil`\" != \"\" && sudo dscacheutil -flushcache; \
                test \"`which discoveryutil`\" != \"\" && sudo discoveryutil mdnsflushcache && sudo discoveryutil udnsflushcaches; \
                test \"`which mDNSResponder`\" != \"\" && sudo killall -HUP mDNSResponder"
