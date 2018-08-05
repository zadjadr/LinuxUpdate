#!/bin/bash

NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'


clear

echo -e "${BOLD}Hi, $USER, I'm updating ${GREEN}Manjaro ${NONE}${BOLD}for you."
echo -e "${NONE}Please give me sudo-rights."
echo 

sudo pacman-key --init
echo -e "${BOLD}Initialized the keyring."
echo

echo -e "${BOLD}Populating the keyring and refreshing it.. ${NONE}"
echo
sudo pacman-key --populate archlinux manjaro
sudo pacman-key --refresh-keys
echo

read -p $'\033[1m\033[01;32m::\033[00m\033[1m Do you want to update the mirrorlist? (y/n)  \033[00m' -n 1 -r
echo
case $REPLY in
    y|Y)
	echo "Updating the mirrorlist.."
	echo
	sudo pacman-mirrors -g --geoip;;
    n|N)
	echo "Okay, not updating mirrorlist.";;
    * ) echo "Invalid";;
esac

echo "Searching for updates.."
echo
sudo pacman -Syu
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
