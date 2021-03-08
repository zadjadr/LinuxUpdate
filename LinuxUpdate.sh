#!/bin/bash

set -o pipefail

RESET='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

BASE_DISTRO=$(cat /etc/*release | grep -oP 'ID_LIKE=\K\w+')
REAL_DISTRO=$(cat /etc/*release | grep -oP '^ID=\K\w+')

if [[ -z "$BASE_DISTRO" ]]; then
    BASE_DISTRO=$REAL_DISTRO
fi

function update_arch_based_mirror_lists() {
    reflector --verbose -l 5 --sort rate --save /etc/pacman.d/mirrorlist
}

function install_yay() {
    yay -Syu;
    if [ "$?" != 0 ]; then
        echo -e "\033[1m\033[01;32m::\033[00m\033[1m Installing latest version of yay \033[00m"
        mkdir /tmp/yay && cd /tmp/yay
        ARCH=$(uname -m)
        URL=$(curl -s https://api.github.com/repos/Jguer/yay/releases/latest | grep "browser_download_url.*${ARCH}.*tar.gz" | cut -d '"' -f 4 )
        curl -LJ $URL -o yay.tar.gz
        tar xfz yay.tar.gz
        sudo mv yay*/yay /usr/local/bin/yay
        rm -r -f yay*
        yay -Syu
    fi
}

clear
echo -e "${BOLD}Hi, $(whoami), I'm updating ${CYAN}${REAL_DISTRO}${BOLD} ${RESET}for you."
echo -e "${RESET}Please give me sudo-rights."
echo

if [ "$BASE_DISTRO" = "arch" ]; then
    sudo pacman-key --init
    echo -e "${BOLD}Initialized the keyring."
    echo

    echo -e "${BOLD}Populating the keyring and refreshing it.. ${RESET}"
    echo

    populate_keys="sudo pacman-key --populate archlinux"

    echo $BASE_DISTRO
    echo $REAL_DISTRO

    if [[ $REAL_DISTRO != "arch" ]]; then
        eval "$populate_keys $REAL_DISTRO"
    else
        eval $populate_keys
    fi

    sudo pacman-key --refresh-keys

    echo
    echo "Updating the mirrorlist (uses 'reflector').."
    echo
    update_arch_based_mirror_lists;
    echo

    sudo pacman -Syu --noconfirm

    echo -e "\033[1m\033[01;32m::\033[00m\033[1m Updating AUR packages (yay will be installed, if not already there) \033[00m"
    install_yay;

    echo
    echo -e "${RED}Removing ${NONE}old stuff from your cache.."
    echo

elif [ "$BASE_DISTRO" = "debian" ]; then
    sudo apt update
    sudo apt -y full-upgrade
else
    echo -e "Sorry, I don't know how to update ${BASE_DISTRO}, yet."
    exit 1
fi
