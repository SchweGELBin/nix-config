{ inputs, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    config = {
      whitelist.prefix = [ "/home/michi" ];
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
