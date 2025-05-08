{ inputs, ... }:
{
  imports = [
    ../../modules/hm
    inputs.catppuccin.homeModules.default
  ];

  # Custom modules
  alacritty.enable = true;
  android-sdk.enable = true;
  cava.enable = true;
  devshells = {
    enable = true;
    bevy.enable = true;
  };
  direnv.enable = true;
  element.enable = true;
  firefox.enable = true;
  hm-pkgs.home.enable = true;
  hypr.enable = true;
  kitty.enable = true;
  mako.enable = true;
  theme.gtk.enable = true;
  vesktop.enable = true;
  waybar.enable = true;
}
