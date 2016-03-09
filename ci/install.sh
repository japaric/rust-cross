#!/bin/bash

set -ex

sudo apt-get install -qq gcc-arm-linux-gnueabihf

# Install multirust
git clone https://github.com/brson/multirust
pushd multirust
./build.sh
./install.sh --prefix=~/multirust
popd

multirust default $RUST_CHANNEL
