#!/bin/bash

# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./src/healpy/cfitsio
cp $BUILD_PREFIX/share/gnuconfig/config.* ./src/healpy/healpixsubmodule/src/cxx/autotools

set -ex

C_SRC_DIR="src/C/autotools"
CXX_SRC_DIR="src/cxx"

# Get the correct version number from the CXX configure.ac file and update the C equivalent
echo "Before: $(grep AC_INIT "${SRC_DIR}/${C_SRC_DIR}/configure.ac")"
sed -i "s/\(AC_INIT([^,]*,[[:space:]]*\[\)[^]]*\(\][[:space:]]*,\?.*)\)/\1$(sed -n 's/^[[:space:]]*AC_INIT([^,]*,[[:space:]]*\[\([^]]*\)\].*/\1/p' ${CXX_SRC_DIR}/configure.ac)\2/" ${C_SRC_DIR}/configure.ac

# Check the new configure.ac AC_INIT
cd ${C_SRC_DIR}
echo "After: $(grep AC_INIT "./configure.ac")"

# rebuild configure script
autoreconf --install

# configure
./configure \
  --disable-static \
  --enable-shared \
  --prefix=${PREFIX}

[[ "$target_platform" == "win-64" ]] && patch_libtool

# build
make -j ${CPU_COUNT}

# test (not when cross compiling)
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" ]]; then
  make -j ${CPU_COUNT} check
fi

# install
make -j ${CPU_COUNT} install
