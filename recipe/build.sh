#!/bin/sh
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./glib
cp $BUILD_PREFIX/share/libtool/build-aux/config.* .

mkdir -p ${PREFIX}/include

# rattler-build sets PYTHON to the host prefix, but the bundled GLib needs a
# build-platform Python while configuring.
export PYTHON="${BUILD_PREFIX}/bin/python"

if [[ "$target_platform" == linux-* ]]; then
  # pkg-config sources are not ready for C23 yet (e.g. use of C23-keyword `bool` as variable name)
  export CFLAGS="${CFLAGS} -std=gnu17"
fi

if [[ "$target_platform" == osx-* ]]; then
  export CFLAGS="${CFLAGS} -Wno-int-conversion"
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  export GLIB_CFLAGS="-I${PREFIX}/include/glib-2.0 -I${PREFIX}/lib/glib-2.0/include"
  export GLIB_LIBS="-L${PREFIX}/lib -lglib-2.0"
  ./configure --prefix=${PREFIX}    \
              --host=${HOST}        \
              --without-internal-glib || (cat config.log; false)
else
  ./configure --prefix=${PREFIX}    \
              --host=${HOST}        \
              --with-internal-glib || (cat config.log; false)
fi

make -j${CPU_COUNT} ${VERBOSE_AT}
make install

# conda customization for CDT packages, emitted for other OSes too incase of cross-compilation
mv ${PREFIX}/bin/pkg-config ${PREFIX}/bin/pkg-config.bin
cp "${RECIPE_DIR}"/pkg-config ${PREFIX}/bin
rm -f ${PREFIX}/bin/${HOST}-pkg-config
ln -s ${PREFIX}/bin/pkg-config ${PREFIX}/bin/${HOST}-pkg-config
chmod +x ${PREFIX}/bin/pkg-config ${PREFIX}/bin/${HOST}-pkg-config
