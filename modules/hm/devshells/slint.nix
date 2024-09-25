let
  pkgs = import <nixpkgs> { };

  libraries =
    with pkgs;
    [
    ];

  packages = with pkgs; [
    jdk17
  ];
in
pkgs.mkShell {
  buildInputs = packages;

  nativeBuildInputs = with pkgs; [ pkg-config ];

  shellHook = ''
    ndk_version=$(grep "^Pkg.Revision" $NDK_HOME/source.properties | awk -F'=' '{print $2}' | tr -d ' ')
    export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=$ANDROID_HOME/ndk/$ndk_version/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android34-clang
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
    export JAVA_HOME=${pkgs.jdk17}/lib/openjdk
    #cargo install cargo-apk
  '';
}
