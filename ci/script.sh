set -ex

main() {
  # Done in ci/install.sh
  #install_c_toolchain
  install_standard_crates
  configure_cargo
  test_cargo_project
}

install_standard_crates() {
  rustup target add $TARGET
}

configure_cargo() {
  local prefix

  case "$TARGET" in
    aarch64-unknown-linux-gnu)
      prefix=aarch64-linux-gnu
      ;;
    arm*-unknown-linux-gnueabihf)
      prefix=arm-linux-gnueabihf
      ;;
    arm-unknown-linux-gnueabi)
      prefix=arm-linux-gnueabi
      ;;
    mipsel-unknown-linux-musl)
      prefix=mipsel-openwrt-linux
      ;;
    x86_64-pc-windows-gnu)
      prefix=x86_64-w64-mingw32
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

  if [[ "$TARGET" =~ "windows" ]]; then
    file target/$TARGET/debug/hello.exe
  else
    file target/$TARGET/debug/hello
  fi
}

main
