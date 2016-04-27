#!/usr/bin/env bash

function doIt() {
    rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
          -avh --no-perms $* . ~;
    ! [[ $* =~ 'dry-run' ]] && source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt;
else
    echo "Those files/directories will be copied into you home directory:";
    echo "";
    doIt --dry-run;
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    else
        echo "Abort"
    fi;
fi;
unset doIt;
