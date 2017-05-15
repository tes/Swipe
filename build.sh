#!/bin/bash +x

set +x

MAJOR_VERSION="$(node -e "console.log(require('./package.json').version);" | cut -d"." -f1,2)"
bold="\033[1m"
colour="\033[32m"
reset="\033[0m"

install_node() {
  NODE_VERSION="$(cat .nvmrc)"

  if test ! $(which nvm)
  then
    if ! [ -f /root/.nvm/nvm.sh ]
    then
      NVM=/root/.nvm/nvm.sh
    else
      NVM=$NVM_DIR/nvm.sh
    fi
    source $NVM
  fi

  nvm install $NODE_VERSION && nvm use $NODE_VERSION
	node --version
}

info () {
	echo -e "\n\n$bold $colour Info... $reset\n"
	echo "  MAJOR_VERSION: $MAJOR_VERSION"
	echo "  BUILD_NUMBER: $BUILD_NUMBER"
	echo "  VERSION: $MAJOR_VERSION.$BUILD_NUMBER"
}

install () {
	echo -e "\n\n$bold $colour Install...$reset\n"
  install_node
	npm install
}

build () {
	echo -e "\n\n$bold $colour Build...$reset\n"
	npm version "$MAJOR_VERSION.$BUILD_NUMBER"
	npm ls --json > npmls.json
}

publish () {
	echo -e "\n\n$bold $colour Publish...$reset\n"
	npm publish
}

info
install
build
publish
