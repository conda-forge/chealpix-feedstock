#!/bin/bash

set -ex

pushd src/C/autotools

# update version number (HACK)
sed -i'' -e "/AC_INIT/c\AC_INIT([chealpix], [${PKG_VERSION}], [healpix-support@lists.sourceforge.net])" configure.ac

head -n 1 configure.ac

# rebuild configure script
autoreconf --install

# configure
./configure --prefix=${PREFIX}

# build
make -j ${CPU_COUNT}

# test
make -j ${CPU_COUNT} check

# install
make -j ${CPU_COUNT} install
