#!/bin/bash

set -ex

main() {
  # Done in ci/install.sh
  #install_c_toolchain
  install_standard_crates
  configure_cargo
  test_cargo_project
}

install_standard_crates() {
  multirust add-target nightly $TARGET
}

configure_cargo() {
  local prefix

  case "$TARGET" in
    arm*gnueabihf)
      prefix=arm-linux-gnueabihf
      ;;
    arm*gnueabi)
      prefix=arm-linux-gnueabi
      ;;
    mipsel-*musl)
      prefix=mipsel-openwrt-linux
      ;;
    *)
      return
      ;;
  esac

  mkdir -p ~/.cargo

  cat >>~/.cargo/config <<EOF
[target.$TARGET]
linker = "$prefix-gcc"
EOF
}

test_cargo_project() {
  cargo new --bin hello

  cd hello
  cargo build --target $TARGET

  file target/$TARGET/debug/hello
}

main
