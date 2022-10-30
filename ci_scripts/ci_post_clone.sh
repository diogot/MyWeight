#!/bin/zsh

set -e

brew install rbenv
eval "$(rbenv init -)"
echo `cat ${CI_PRIMARY_REPOSITORY_PATH}/.ruby-version`
rbenv install `cat ${CI_PRIMARY_REPOSITORY_PATH}/.ruby-version`
gem install bundler
gem list | grep bundler
rake setup
