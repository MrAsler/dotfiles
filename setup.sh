#!/usr/bin/env bash

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo ${machine}

if [ "$machine" = "Linux" ]; then
 ./setup-arch.sh 
elif [ "$machine" = "Mac" ]; then 
 ./setup-macos.sh 
else
  echo "Unknown machine! $machine"
fi
