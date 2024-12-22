{
  inputs,
  pkgs,
  ...
}:
let
  vars = import ../../modules/nix/vars.nix;
in
{
  home = {
    homeDirectory = "${vars.user.home}";
    stateVersion = "${vars.user.stateVersion}";
    username = "${vars.user.name}";
  };

  imports = [
    ../../modules/hm
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  home.packages = with pkgs; [
    nixfmt-rfc-style
    wireguard-tools
  ];

  programs = {
    bat.enable = true;
    bash.enable = true;
    btop.enable = true;
    git.enable = true;
    home-manager.enable = true;
    htop.enable = true;
    zsh.enable = true;
  };
}
