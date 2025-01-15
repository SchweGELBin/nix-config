let
  pkgs = import <nixpkgs> { };

  libraries = with pkgs; [
    alsa-lib
    libxkbcommon
    udev
    vulkan-loader
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];

  packages = with pkgs; [
    pkg-config
  ];
in

pkgs.mkShell {
  buildInputs = packages;

  shellHook = "export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH";
}
