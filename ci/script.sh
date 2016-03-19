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

  mkdir -p ~/.cargo

  case "$TARGET" in
    arm*gnueabihf)
      prefix=arm-linux-gnueabihf
      ;;
    mipsel-*musl)
      prefix=mipsel-openwrt-linux
      ;;
  esac

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
