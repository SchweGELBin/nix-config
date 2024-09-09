{ inputs, pkgs, ... }:
let
  vars = import ../../modules/nix/vars.nix;
in
{
  home.username = "${vars.user.name}";
  home.homeDirectory = "${vars.user.home}";
  programs.home-manager.enable = true;

  home = {
    stateVersion = "24.11";
  };

  imports = [
    ../../modules/hm
    inputs.nixvim.homeManagerModules.nixvim
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  home.packages = with pkgs; [
    nixfmt-rfc-style
  ];

  programs = {
    bat.enable = true;
    bash.enable = true;
    btop.enable = true;
    git.enable = true;
    zsh.enable = true;
  };
}
