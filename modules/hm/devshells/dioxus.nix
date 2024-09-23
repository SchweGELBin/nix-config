let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  buildInputs = with pkgs; [
    dioxus-cli
    openssl_3
    pkg-config
  ];
  shellHook = ''
    ndk_version=$(grep "^Pkg.Revision" $NDK_HOME/source.properties | awk -F'=' '{print $2}' | tr -d ' ')
    export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=$ANDROID_HOME/ndk/$ndk_version/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android34-clang
    cargo install cargo-mobile2
  '';
}
