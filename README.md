# LinuxUpdate

[![LinuxUpdate on Ubuntu & Arch](https://github.com/Xcalizorz/LinuxUpdate/actions/workflows/test-update.yml/badge.svg)](https://github.com/Xcalizorz/LinuxUpdate/actions/workflows/test-update.yml)

This is a small bash script that can update all Arch and Debian Distros, create a new mirrorlist and delete old stuff (only arch).
I didn't like typing all the code in everytime, so I created a small bash script -
maybe you're like me and I can help you with this :)
\
The plan is to create an easy command-line tool for (almost) all Linux Distros.

- [LinuxUpdate](#LinuxUpdate)
  - [Install](#Install)
  - [Usage](#Usage)
    - [Use the cli](#Use-the-cli)
    - [Use the .desktop file](#Use-the-desktop-file)
  - [Example of Usage on Manjaro](#Example-of-Usage-on-Manjaro)
    - [Updating the mirrorlist](#Updating-the-mirrorlist)
    - [Removing old stuff](#Removing-old-stuff)

## Install

You will first need any Arch or Debian (e. g. Ubuntu) based Distro installed.
Since I just started looking at bash, it might take a little bit to upload scripts for different linux distributions.

## Usage

### Prerequisites

#### Arch based

Install the following packages, to make this script work:

```bash
  pacman -S sudo reflector
```

#### Debian based

Install the following packages, to make this script work:

```bash
  apt install bash sudo
```

### Use the cli

```bash
  $ cd /to/LinuxUpdate/
  $ chmod +x LinuxUpdate.sh
  $ ./LinuxUpdate.sh
```

### Use the .desktop file

Open the file in any texteditor and change the `Exec`-parameter
\
You need to insert the correct path to `LinuxUpdate.sh`.

Then give the neccessary permissions to run this file:

    $ chmod +x LinuxUpdate.desktop

Now you have a shortcut and can start the update via double-click.

## Example of Usage on Manjaro

### Updating the mirrorlist

![Mirrorlist Update](img/mirrorupdate.png)

### Removing old stuff

![Removing old stuff](img/removingStuff.png)
