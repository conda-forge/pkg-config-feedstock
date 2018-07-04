if [[ ! -z "${CONDA_BUILD}" && ! -z "${PREFIX}" ]]; then
  if [[ ! -z "${PKG_CONFIG_PATH}" ]]; then
    export _CONDA_SAVE_PKG_CONFIG_PATH="${PKG_CONFIG_PATH}"
  fi
  export PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig"
fi
