{ inputs, pkgs, ... }:
let
  vars = import ../nix/vars.nix;
in
{
  programs.direnv = {
    enable = true;
    config = {
      whitelist.prefix = [ "${vars.user.home}" ];
    };
    package = pkgs.direnv;
    enableBashIntegration = false;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      package = inputs.nix-direnv.packages.${pkgs.system}.nix-direnv;
    };
  };
}
