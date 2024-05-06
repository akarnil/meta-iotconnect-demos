#!/bin/bash

ssh-add -L
sudo chown user:user /src/ -R
cd /src/
ssh-keyscan -p 9418 -t rsa msc-git02.msc-ge.com >> ~/.ssh/known_hosts
git clone ssh://gitolite@msc-git02.msc-ge.com:9418/msc_ol99/msc-ldk
ssh-keyscan -t rsa bitbucket.org >> ~/.ssh/known_hosts
git clone git@bitbucket.org:adeneo-embedded/b0000-internal-pluma-linux-advanced-test-suite.git
cd msc-ldk/
git checkout v1.11.0
pip3 install sphinx
sudo apt update && sudo apt install -y parted mtools
./setup.py --bsp=01047
cp -r /src/yocto-layers/ /src/msc-ldk/sources/meta-iotconnect-demos/
git clone git@github.com:avnet-iotconnect/meta-iotconnect.git /src/msc-ldk/sources/meta-iotconnect/

#if [ $1 = "test" ]; then
  cp -r /src/b0000-internal-pluma-linux-advanced-test-suite/meta-lats/meta-lats-kirkstone/ /src/msc-ldk/sources/
#fi

source sources/yocto.git/oe-init-build-env build/01047
bitbake-layers add-layer ../../sources/meta-iotconnect/
bitbake-layers add-layer ../../sources/meta-iotconnect-demos/
#if [ $1 = "test" ]; then
  bitbake-layers add-layer ../../sources/meta-lats-kirkstone/
  echo -e '\nIMAGE_INSTALL += " ltp rng-tools iotc-c-sdk"' >> conf/local.conf
  echo -e '\nIMAGE_FEATURES += " ssh-server-openssh"' >> conf/local.conf
  echo -e '\nEXTRA_IMAGE_FEATURES += " ptest-pkgs"' >> conf/local.conf
  echo -e '\nDISTRO_FEATURES += " pam systemd wifi ptest bluetooth"' >> conf/local.conf
#else
#  echo -e '\nIMAGE_INSTALL += " iotc-c-sdk"' >> conf/local.conf
#fi

cat conf/local.conf
bitbake core-image-base
