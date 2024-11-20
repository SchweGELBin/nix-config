{
  inputs,
  pkgs,
  ...
}:
let
  vars = import ../../modules/nix/vars.nix;
in
{
  home.username = "${vars.user.name}";
  home.homeDirectory = "${vars.user.home}";
  programs.home-manager.enable = true;

  home = {
    stateVersion = "${vars.user.stateVersion}";
  };

  imports = [
    ../../modules/hm
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
