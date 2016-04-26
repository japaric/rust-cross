set -ex

install_c_toolchain() {
    case $TARGET in
        aarch64-unknown-linux-gnu)
            sudo apt-get install -y --force-yes --no-install-recommends \
                 gcc-aarch64-linux-gnu libc6-arm64-cross libc6-dev-arm64-cross
            ;;
        *)
            # For other targets, this is handled by addons.apt.packages in .travis.yml
            ;;
    esac
}

install_rustup() {
  curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain=nightly
    
  rustc -V
  cargo -V
}

install_openwrt_sdk() {
  local root_url="https://downloads.openwrt.org/snapshots/trunk/malta/generic/"
  local tarball=$(curl $root_url  | grep SDK | cut -d'"' -f2)
  local filename="${tarball%.*}"
  filename="${filename%.*}"

  mkdir $STAGING_DIR
  curl -sL "${root_url}/${tarball}" | \
    tar --strip-components 2 -C $STAGING_DIR -xj "${filename}/staging_dir"

  PATH="$PATH:$(find $STAGING_DIR -maxdepth 1 -name 'toolchain*' -print -quit)/bin" \
    mipsel-openwrt-linux-gcc -v
}

main() {
  install_c_toolchain
  install_rustup
  if [ "$TARGET" = "mipsel-unknown-linux-musl" ]; then
    install_openwrt_sdk
  fi
}

main
