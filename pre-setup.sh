#!/bin/bash

echo '### STARTING PRE SETUP ###'

cd $HOME
sudo apt update -y
sudo apt install -y curl ca-certificates gnupg apt-transport-https tree xclip

echo '### FINISHING PRE SETUP ###'
