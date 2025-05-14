{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.theme;
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = true;
      accent = vars.cat.accent;
      cava.transparent = true;
      flavor = vars.cat.flavor;
      hyprlock.useDefaultConfig = false;
      mako.enable = false;
    };

    gtk = lib.mkIf cfg.gtk.enable {
      enable = true;
      iconTheme = {
        name = "Dracula";
        package = pkgs.dracula-icon-theme;
      };
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
    };

    home.pointerCursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = vars.theme.cursor.size;
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
