{ config, lib, pkgs, ... }:
with config.lib.stylix.colors.withHashtag;
{
  home.file.".config/waybar/config".source = ./config;
  home.file.".config/waybar/style.css".source = ./style.css;
  home.file.".config/waybar/modules.jsonc".source = ./modules.jsonc;

  home.file.".config/waybar/colors.css".text = ''
    @define-color bd ${base0A}; /* Border     */
    @define-color bg ${base00}; /* Background */
    @define-color fg ${base05}; /* Foreground */
  '';
}
