{
  config,
  lib,
  pkgs,
  ...
}:
let
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf config.theme.enable {
    catppuccin = {
      enable = true;
      accent = vars.cat.accent;
      flavor = vars.cat.flavor;
      pointerCursor.enable = true;
    };

    gtk = lib.mkIf config.theme.gtk.enable {
      enable = true;
      catppuccin.icon.enable = false;
      iconTheme = {
        name = "Dracula";
        package = pkgs.dracula-icon-theme;
      };
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };
  };

  options = {
    theme = {
      enable = lib.mkEnableOption "Enable Theme";
      gtk.enable = lib.mkEnableOption "Enable GTK Theme";
    };
  };
}
