#!/bin/bash

# Installation script.
# 
# This script clones the repository from github to $HOME/.dotfiles.
#
# Author: Benoist LAURENT <benoist.laurent@gmail.com>
# 
# Adapted from https://github.com/gf3/dotfiles/blob/v1.0.0/bootstrap.sh.


# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    COLOR_OFF="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    COLOR_OFF=""
fi

# Set the DOTFILES path either to $HOME/.dotfiles or to the current directory
# unless provided in environment.
if [ ! -n "$DOTFILES" ]; then
    # We are in the dotfiles directory.
    if grep -q 'url.*dotfiles.git' $(pwd)/.git/config; then
        DOTFILES=$(pwd)
    else
        DOTFILES=$HOME/.dotfiles
    fi
fi

# Notice message
notice() { echo -e "$BOLD$GREEN=> $1$COLOR_OFF"; }

# Error message
error() { echo -e "$RED=> Error: $1$COLOR_OFF"; }

# Warning message
warning() { echo -e "$YELLOW=> Warning: $1$COLOR_OFF"; }

# List item
c_list() { echo -e "  $BOLD$GREEN ✔$COLOR_OFF $1"; }

# Error list item
e_list() { echo -e "  $RED ✖$COLOR_OFF $1"; }

# Return true if an array contains a file.
#
# Args:
#     filename: file to look for in `filelist`
#     ... : list of files
#
in_array() {
    [[ $# < 1 ]] && error "usage: in_array <file> [exclude1 ...]" && exit 1
    local filelist filename=$1
    shift
    for filelist; do
        [[ $filelist == $filename ]] && return 0
    done
    return 1
}

# Check for dependency by trying to run a command.
# Nicely display the result.
dep() {
    [[ $# -ne 1 ]] && error "usage: dep <command>" && exit 1
    type -p $1 &> /dev/null
    local installed=$?
    if [ $installed -eq 0 ]; then
        c_list $1
    else
        e_list $1
    fi
    return $installed
}

# Check if all dependencies are met, else exit.
#
# Args
#     dependencies: list of dependencies
#
check_dependencies() {
    [[ $# -ne 1 ]] && error "usage: check_dependencies <dependencies>" && exit 1
    dependencies=$1
    not_met=0
    for need in "${dependencies[@]}"; do
        dep $need
        met=$?
        not_met=$(echo "$not_met + $met" | bc)
    done

    if [ $not_met -gt 0 ]; then
        error "$not_met dependencies not met!"
        exit 1
    fi
}

# Backup already present dotfiles to a backup directory.
#
# Args:
#     backupdir: path to dotfiles backup directory
#     excluded: list of items to be excluded from backup
#
backup() {
    [[ $# -ne 2 ]] && error "usage: backup <backupdir> <excluded>" && exit 1
    pushd $DOTFILES > /dev/null
    backupdir=$1
    excluded=$2
    mkdir -p $backupdir
    local files=( $(ls -A) )
    for file in "${files[@]}"; do
        if ! in_array $file "${excluded[@]}" && [ -e "$HOME/$file" ]; then
            cp -rf "$HOME/$file" "$backupdir/$file"
        fi
    done
    popd > /dev/null
}

# Copy all files and directories in current directory to the HOME directory 
# unless listed in an exclusion list.
#
# Args:
#     excluded: list of items to be excluded from backup
#
install() {
    pushd $DOTFILES > /dev/null
    [[ $# -ne 1 ]] && error "usage: install <excluded>" && exit 1
    excluded=$1
    local files=( $(ls -A) )
    for file in "${files[@]}"; do
        if ! in_array $file ${excluded[@]}; then        
            [ -d "$HOME/$file" ] && rm -rf "$HOME/$file"
            cp -rf "$file" "$HOME/$file"
            c_list $file
        fi
    done
    popd > /dev/null
}

# Retrieve dotfiles from github or update the current repository.
get_dotfiles() {
    # Install from GitHub: clone repository to $HOME/.dotfiles
    if ! [ -d $DOTFILES ]; then
        notice "Downloading from GitHub"
        git clone --recursive https://github.com/benoistlaurent/dotfiles.git $HOME/.dotfiles
    # Install from local repository: update repository and subrepositories
    else
        notice "Updating repositories"
        pushd $DOTFILES > /dev/null
        git pull origin master
        if [ "$?" != 0 ]; then
            warning "Cannot update repository"
        else
            git submodule init
            git submodule update
        fi
        git submodule init
        git submodule update
        popd > /dev/null
    fi
}

main() {

    # Initialize.
    backupdir="$HOME/.dotfiles-backup/$(date "+%Y-%m-%d-%H%M.%S")"
    dependencies=(git pygmentize)
    excluded=(.git .gitignore .gitmodules bootstrap.sh Molotov.itermcolors README.rst)

    # Dependencies.
    notice "Checking dependencies"
    check_dependencies $dependencies

    # Retrieve dotfiles.
    get_dotfiles

    # Backup
    notice "Backup up old files to $backupdir"
    backup $backupdir $excluded

    # Install.
    notice "Installing"
    install $excluded
}

main
