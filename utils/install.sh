#!/usr/bin/env bash
rm -rf /usr/local/bin/dropboxignore/*
git clone https://github.com/sp1thas/dropboxignore.git
sudo dropboxignore/make install
rm -rf dropboxignore/