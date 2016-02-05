#!/bin/bash

set -ex

triple=arm-unknown-linux-gnueabihf
prefix=arm-linux-gnueabihf

main() {
  # Done in .travis.yml
  #install_c_toolchain

  install_standard_crates

  configure_cargo

  test_cargo_project
}

# TODO replace this with multirust add-target $triple
install_standard_crates() {
  local tarball=
  local version=

  case "$TRAVIS_RUST_VERSION" in
    stable)
      version=$(rustc -V | cut -d' ' -f2 | cut -d'-' -f1)
      tarball="rust-std-${version}-arm-unknown-linux-gnueabihf.tar.gz"
      ;;
    beta)
      tarball="rust-std-beta-arm-unknown-linux-gnueabihf.tar.gz"
      ;;
    nightly)
      tarball="rust-std-nightly-arm-unknown-linux-gnueabihf.tar.gz"
      ;;
  esac

  mkdir tmp

  pushd tmp
  curl -O "http://static.rust-lang.org/dist/$tarball"
  tar xzf "$tarball"
  pushd rust-*
  ./install.sh --prefix=$(rustc --print sysroot)

  popd
  popd

  rm -r tmp
}

configure_cargo() {
  mkdir -p ~/.cargo

  cat >>~/.cargo/config <<EOF
[target.$triple]
ar = "$prefix-ar"
linker = "$prefix-gcc"
EOF
}

test_cargo_project() {
  cargo new --bin hello

  cd hello
  cargo build --target $triple

  file target/$triple/debug/hello
}

main
