#!/usr/bin/env bash

set -x
set -e

# install libzmq from pre-build binary package
install_zeromq_apt(){
  sudo sh -c "echo 'deb http://download.opensuse.org/repositories/network:/messaging:/zeromq:/release-stable/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/network:messaging:zeromq:release-stable.list"
  sudo apt-get update
  sudo apt-get install libzmq3-dev
}

# install libzmq from source
install_zeromq_source() {
  pushd .

  mkdir libzmq
  cd libzmq
  curl -L https://github.com/zeromq/libzmq/archive/v${ZMQ_VERSION}.tar.gz >zeromq.tar.gz
  tar -xvzf zeromq.tar.gz
  cd libzmq-${ZMQ_VERSION}

  mkdir build
  cd build
  cmake -DZMQ_BUILD_TESTS=OFF ..
  sudo make -j4 install

  popd
}

# build cppzmq from source
install_cppzmq_source() {
  pushd .

  mkdir -p build
  cd build
  cmake -DCPPZMQ_BUILD_TESTS=OFF ..
  sudo make -j4 install

  popd
}

if [ "${ZMQ_VERSION}" == "" ] ; then
  export ZMQ_VERSION=4.2.5
fi
install_zeromq_apt
install_cppzmq_source
