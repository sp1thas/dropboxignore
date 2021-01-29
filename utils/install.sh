#!/usr/bin/env bash
rm -rf /usr/local/bin/dropboxignore/*
git clone https://github.com/sp1thas/dropboxignore.git
cd dropboxignore/
sudo make install
cd .. && rm -rf dropboxignore/