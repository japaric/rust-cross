set -ex

install_rustup() {
  local td=$(mktemp -d)

  pushd $td
  curl -O https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-setup
  chmod +x rustup-setup
  ./rustup-setup -y
  popd

  rm -r $td

  rustup default nightly
    
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
  install_rustup
  if [ "$TARGET" = "mipsel-unknown-linux-musl" ]; then
    install_openwrt_sdk
  fi
}

main
