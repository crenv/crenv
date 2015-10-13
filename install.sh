#!/bin/bash

set -e

if [ "$CRENV_ROOT" == "" ]; then
  CRENV_ROOT="$HOME/.crenv"
fi

if [ -d "$CRENV_ROOT" ]; then
  echo "=> crenv is already installed in $CRENV_ROOT, trying to update"

  echo -ne "\r=> "
  cd $CRENV_ROOT && git pull

  if [ -d "$CRENV_ROOT/plugins/crystal-build" ]; then
    echo -ne "\r=> "
    cd $CRENV_ROOT/plugins/crystal-build && git pull
  fi

  exit
fi

echo "=> Cloning crenv repository"
git clone https://github.com/pine613/crenv.git "$CRENV_ROOT"

echo
echo "=> Cloning crenv plugin repositories"
git clone https://github.com/pine613/crystal-build.git "$CRENV_ROOT/plugins/crystal-build"
git clone https://github.com/pine613/crenv-update.git "$CRENV_ROOT/plugins/crenv-update"

echo
echo "=> Append the following line to the correct file yourself"
echo
echo -e "\texport PATH=\"\$HOME/.crenv/bin:\$PATH\""
echo -e "\teval \"\$(crenv init -)\""
echo
echo "=> Close and reopen your terminal to start using crenv"
exit
