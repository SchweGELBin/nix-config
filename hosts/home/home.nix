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

  # Custom modules
  alacritty.enable = true;
  cava.enable = true;
  devshells.enable = true;
  direnv.enable = true;
  firefox.enable = true;
  gtk.enable = true;
  hm-pkgs.home.enable = true;
  hypr.enable = true;
  kitty.enable = true;
  mako.enable = true;
  theme.gtk.enable = true;
  vesktop.enable = true;
  waybar.enable = true;
}
