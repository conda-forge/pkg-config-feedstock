#!/bin/sh
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./glib
cp $BUILD_PREFIX/share/libtool/build-aux/config.* .

mkdir -p ${PREFIX}/include

./configure --prefix=${PREFIX}    \
            --host=${HOST}        \
            --without-internal-glib

make -j${CPU_COUNT} ${VERBOSE_AT}
make install

# conda customization for CDT packages, emitted for other OSes too incase of cross-compilation
mv ${PREFIX}/bin/pkg-config ${PREFIX}/bin/pkg-config.bin
cp "${RECIPE_DIR}"/pkg-config ${PREFIX}/bin
rm -f ${PREFIX}/bin/${HOST}-pkg-config
ln -s ${PREFIX}/bin/pkg-config ${PREFIX}/bin/${HOST}-pkg-config
chmod +x ${PREFIX}/bin/pkg-config ${PREFIX}/bin/${HOST}-pkg-config
