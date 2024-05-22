{config, pkgs, ...}:
with config.lib.stylix.colors;
{
  home.file.".config/fuzzel/fuzzel.ini" = {
    text = ''
      [colors]
      background=${base00}ff
      text=${base07}ff
      match=${base07}ff
      selection=${base02}ff
      selection-match=${base03}ff
      selection-text=${base03}ff
      border=${base07}ff
    '';
  };
}
