{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  home.file.".config/waybar/config".source = ./config;
  home.file.".config/waybar/style.css".source = ./style.css;
  home.file.".config/waybar/modules.jsonc".source = ./modules.jsonc;

  programs.waybar = {
    enable = true;
    package = inputs.waybar.packages.${pkgs.system}.waybar;
  };
}
