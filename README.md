#`rust-cross`

Here I'll be writing about the arcane art of cross compiling in the context of Rust.

Here are the topics that I intend to cover, most of it will be a re-hash of my [two] previous
[guides].

[two]: https://github.com/japaric/ruststrap/blob/master/1-how-to-cross-compile.md
[guides]: https://github.com/japaric/rust-on-openwrt

- common terms
- targets and triples
- requirements: C toolchain + cross compiled std
- The C toolchain
  - toolchain = cross compiler (${target}-gcc) + cross compiled libc
  - toolchain libc must match target libc
  - toolchain libc version <= target libc version
- cross compilation using `rustc` and official cross-std nightlies
  - mention that `multirust add-target arm-uknown-linux-gnueabihf` will [someday] become a thing.
- cross compilation using `cargo`
- how to cross compile std, if there's no packaged cross-std for my target
- diagnosing common problems
  - compile: undefined reference -> examine symbols with nm/objdump
  - run: can't load library -> check linker dependencies with ldd
  - run: illegal instruction -> wrong target, e.g. armhf binary in soft float arm host

[someday]: https://github.com/brson/multirust/pull/112
