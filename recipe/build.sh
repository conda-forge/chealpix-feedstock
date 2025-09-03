#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./src/healpy/cfitsio
cp $BUILD_PREFIX/share/gnuconfig/config.* ./src/healpy/healpixsubmodule/src/cxx/autotools

set -ex

pushd src/C/autotools

# update version number (HACK)
sed -i'' -e "/AC_INIT/c\AC_INIT([chealpix], [${PKG_VERSION}], [healpix-support@lists.sourceforge.net])" configure.ac

head -n 1 configure.ac

# rebuild configure script
autoreconf --install

# configure
./configure --prefix=${PREFIX}

[[ "$target_platform" == "win-64" ]] && patch_libtool

# build
make -j ${CPU_COUNT}

# test (not when cross compiling)
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
	make -j ${CPU_COUNT} check
fi

# install
make -j ${CPU_COUNT} install
