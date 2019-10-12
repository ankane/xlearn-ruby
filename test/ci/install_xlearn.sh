#!/usr/bin/env bash

set -e

CACHE_DIR=$HOME/xlearn/$XLEARN_VERSION

if [ ! -d "$CACHE_DIR" ]; then
  wget -O xlearn-$XLEARN_VERSION.tar.gz https://github.com/aksnzhy/xlearn/archive/v$XLEARN_VERSION.tar.gz
  tar xvfz xlearn-$XLEARN_VERSION.tar.gz
  mv xlearn-$XLEARN_VERSION $CACHE_DIR
  cd $CACHE_DIR
  mkdir build
  cd build
  cmake ..
  make
else
  echo "xLearn cached"
fi
