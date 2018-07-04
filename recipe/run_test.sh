set -ex

activate="$PREFIX/etc/conda/activate.d/${PKG_NAME}_activate.sh"
deactivate="$PREFIX/etc/conda/deactivate.d/${PKG_NAME}_deactivate.sh"

# start fresh:
unset PKG_CONFIG_PATH
unset _CONDA_SAVE_PKG_CONFIG_PATH

source $activate
test "$PKG_CONFIG_PATH" = "$PREFIX/lib/pkgconfig"
source $deactivate
test -z "$PKG_CONFIG_PATH"

# preserve PKG_CONFIG_PATH before/after
export PKG_CONFIG_PATH="before"
source $activate
test "$PKG_CONFIG_PATH" = "$PREFIX/lib/pkgconfig"
test "$_CONDA_SAVE_PKG_CONFIG_PATH" = "before"
source $deactivate
test "$PKG_CONFIG_PATH" = "before"
test -z "$_CONDA_SAVE_PKG_CONFIG_PATH"

# don't set anything if PREFIX or CONDA_BUILD is undefined
export PREFIX=""
source $activate
test "$PKG_CONFIG_PATH" = "before"
source $deactivate
