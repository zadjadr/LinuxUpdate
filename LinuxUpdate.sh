#!/bin/bash

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

if [ "$BASE_DISTRO" = "" ]; then
    BASE_DISTRO=$REAL_DISTRO
fi

function update_arch_based_mirror_lists() {
    if [ "$REAL_DISTRO" != "arch" ]; then
        sudo pacman-mirrors --interactive --default
    else
        cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
        echo "/etc/pacman.d/mirrorlist -> /etc/pacman.d/mirrorlist.backup"
        sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.backup
        rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
    fi
}

function install_yay() {
    yay -Syu;
    if [ "$?" != 0 ]; then
        read -p $'\033[1m\033[01;32m::\033[00m\033[1m Install yay? (y/n) \033[00m' -n 1 -r
        case $REPLY in
            y|Y)
                echo -e "\n Installing yay - version 10.1.0"
                mkdir /tmp/yay && cd /tmp/yay
                curl -LJO https://github.com/Jguer/yay/releases/download/v10.1.0/yay_10.1.0_x86_64.tar.gz
                tar xfz yay_10.1.0_x86_64.tar.gz
                sudo mv yay_10.1.0_x86_64/yay /usr/local/bin/yay
                rm -r -f yay*
                yay -Syu;;
            n|N)
                echo "Okay.";;
            *)
                echo "Invalid";;
        esac
    fi
}

clear
echo -e "${BOLD}Hi, $(whoami), I'm updating ${CYAN}${REAL_DISTRO} ${RESET}${BOLD}for you."
echo -e "${RESET}Please give me sudo-rights."
echo

if [ "$BASE_DISTRO" = "arch" ]; then
    sudo pacman-key --init
    echo -e "${BOLD}Initialized the keyring."
    echo

    echo -e "${BOLD}Populating the keyring and refreshing it.. ${RESET}"
    echo
    sudo pacman-key --populate archlinux "$REAL_DISTRO"
    sudo pacman-key --refresh-keys

    echo
    read -p $'\033[1m\033[01;32m::\033[00m\033[1m Do you want to update the mirrorlist? (y/n) \033[00m' -n 1 -r
    echo
    case $REPLY in
        y|Y)
            echo "Updating the mirrorlist.."
            echo
            update_arch_based_mirror_lists;;
        n|N)
            echo "Okay, not updating mirrorlist.";;
        * ) echo "Invalid";;
    esac

    sudo pacman -Syu
    read -p $'\033[1m\033[01;32m::\033[00m\033[1m Do you want to update AUR packages (yay needed)? (y/n) \033[00m' -n 1 -r
    echo
    case $REPLY in
        y|Y)
            install_yay;;
        n|N)
            echo "Okay, not updating via AUR packages (via yay).";;
        * ) echo "Invalid";;
    esac
    echo

    read -p $'\033[1m\033[01;32m::\033[00m\033[1m Do you want to clear pacmans cache? (y/n)  \033[00m' -n 1 -r
    echo
    case $REPLY in
        y|Y)
            echo -e "${RED}Removing ${NONE}old stuff from your cache.."
            echo
            sudo pacman -Sc;;
        n|N)
            echo "Okay, not clearing pacmans cache.";;
        * ) echo "Invalid";;
    esac
    echo

elif [ "$BASE_DISTRO" = "debian" ]; then
    sudo apt-get update
    sudo apt-get full-upgrade
else
    echo -e "Sorry, I don't know how to update ${BASE_DISTRO}, yet."
    exit 1
fi
