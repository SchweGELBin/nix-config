let
  pkgs = import <nixpkgs> { };

  libraries = with pkgs; [
    libGL
    libxkbcommon
    wayland
  ];
in
pkgs.mkShell {
  shellHook = "export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH";
}
