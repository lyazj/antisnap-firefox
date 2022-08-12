#!/bin/bash

PREFIX=/usr/local
if [ ! $UID = 0 ]; then
    >&2 echo "$0: only root can do this"
    exit 1
fi

set -ve
wget --continue --trust-server-names $(cat url.txt)
ls firefox-*.tar.bz2 | sort --version-sort | head --lines=-1 | xargs rm -f
ARCHIVE_NAME=$(ls firefox-*.tar.bz2)
BASE_NAME=${ARCHIVE_NAME%.*.*}
CWD=$(pwd)
cd ${PREFIX}
if [ -d "${BASE_NAME}" ]; then
    exit 0
fi
mkdir "${BASE_NAME}"
bzip2 -kdc "${CWD}/${ARCHIVE_NAME}" | tar -xC "${BASE_NAME}"
ln -sfT "${BASE_NAME}/firefox" firefox
ls -d firefox-* | sort --version-sort | head --lines=-1 | xargs rm -rf
