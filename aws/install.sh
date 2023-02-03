#!/bin/bash

set -e

git clone https://github.com/tfutils/tfenv.git ~/.tfenv
mkdir -p ~/bin
ln -s ~/.tfenv/bin/* ~/bin
tfenv install 1.2.5
tfenv use 1.2.5
