let
  pkgs = import <nixpkgs> { };

  libraries = with pkgs; [
    alsa-lib
    libxkbcommon
    udev
    vulkan-loader
    wayland
  ];

  packages = [ ];
in

pkgs.mkShell {
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = libraries ++ packages;
  shellHook = "export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH";
}
