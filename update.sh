#!/bin/bash

PREFIX=/usr/local
if [ ! $UID = 0 ]; then
    >&2 echo "$0: only root can do this"
    exit 1
fi

set -ve
mkdir -p ${PREFIX}
wget --continue --trust-server-names $(cat url.txt)
ls firefox-*.tar.bz2 | sort --version-sort | head --lines=-1 | xargs rm -f
ARCHIVE_NAME=$(ls firefox-*.tar.bz2)
BASE_NAME=${ARCHIVE_NAME%.*.*}
CWD=$(pwd)
cd ${PREFIX}
if [ ! -d "${BASE_NAME}" ]; then
    mkdir "${BASE_NAME}"
    bzip2 -kdc "${CWD}/${ARCHIVE_NAME}" | tar -xC "${BASE_NAME}"
fi
ln -sfT "${BASE_NAME}/firefox" firefox
mkdir -p bin
ln -sf ../firefox/firefox bin
mkdir -p share/applications
cp "${CWD}"/firefox-default256.png share/applications
ICON_FILE=$(pwd)/share/applications/firefox-default256.png
sed -e "s/^Icon=.*$/Icon=${ICON_FILE//\//\\\/}/" \
    "${CWD}"/firefox.desktop > share/applications/firefox.desktop
ls -d firefox-* | sort --version-sort | head --lines=-1 | xargs rm -rf
