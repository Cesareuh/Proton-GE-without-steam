# Author Cesareuh
#! /bin/bash

app_help () {
    echo -e "Usage: $0 GAME.exe"
}

if [ $# -eq 0 ]; then
    echo "Missing argument"
    app_help
    exit 2
fi

if [ $# -gt 1 ]; then
    echo "Too many arguments"
    app_help
    exit 2
fi

if [ ! -f $1 ]; then
    echo "File does not exists"
    app_help
    exit 2
fi

# Pfx path is in ~/Games/pfx/GAMENAME
PFX_PATH=~/Games/pfx/$(echo $1 | awk -F "/" '{print $NF}' | awk -F "." '{print $1}')
if [ ! -d $PFX_PATH ]; then
    mkdir -p $PFX_PATH
fi

STEAM_COMPAT_CLIENT_INSTALL_PATH=~/.steam/steam
if [ ! -d $STEAM_COMPAT_CLIENT_INSTALL_PATH ]; then
    echo "No steam installation found in $STEAM_COMPAT_CLIENT_INSTALL_PATH"
    exit 2
fi

# Follow instructions to install Proton-GE on https://github.com/GloriousEggroll/proton-ge-custom?tab=readme-ov-file
PROTON_GE_DIR=~/.steam/root/compatibilitytools.d/
PROTON_GE_VERSIONS=$(ls $PROTON_GE_DIR)
if [ ! -d $PROTON_GE_DIR ] || [ $(wc -l $PROTON_GE_VERSIONS) -eq 0 ]; then
    echo "No Proton-GE installation found in $PROTON_GE_DIR"
    exit 2
fi

SELECTED_VERSION="$(zenity --list --text="Select Proton-GE version" --column="Proton-GE version" $PROTON_GE_VERSIONS)"

PROTON_EXECUTABLE=$PROTON_GE_DIR$SELECTED_VERSION/proton
STEAM_COMPAT_CLIENT_INSTALL_PATH=$STEAM_COMPAT_CLIENT_INSTALL_PATH STEAM_COMPAT_DATA_PATH=$PFX_PATH $PROTON_EXECUTABLE run $1
