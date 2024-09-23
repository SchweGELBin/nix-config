let
  pkgs = import <nixpkgs> { };
  fenix = import (fetchTarball "https://github.com/nix-community/fenix/archive/monthly.tar.gz") { };
in
pkgs.mkShell {
  buildInputs = [
    (fenix.combine [
      fenix.latest.toolchain
      fenix.targets.aarch64-linux-android.latest.rust-std
      fenix.targets.wasm32-unknown-unknown.latest.rust-std
    ])
  ];
}
