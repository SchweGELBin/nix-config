let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  buildInputs = with pkgs; [ flutter ];
  shellHook = "flutter config --no-analytics";
}
