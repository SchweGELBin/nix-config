{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.theme;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = cfg.catppuccin.enable;
      accent = vars.cat.accent;
      flavor = vars.cat.flavor;

      cava.transparent = true;
      cursors.enable = cfg.catppuccin.cursors.enable;
      firefox.profiles = lib.mkIf config.firefox.enable {
        ${vars.user.name}.force = true;
      };
      gtk.icon.enable = cfg.catppuccin.gtk.enable;
    };

    gtk = lib.mkIf cfg.gtk.enable {
      enable = true;
      iconTheme = lib.mkIf (!cfg.catppuccin.gtk.enable) {
        name = "Dracula";
        package = pkgs.dracula-icon-theme;
      };
      theme = {
        name = "Dracula";
        package = pkgs.dracula-theme;
      };
    };

    home.pointerCursor = {
      name = lib.mkIf (!cfg.catppuccin.cursors.enable) "Bibata-Modern-Ice";
      package = lib.mkIf (!cfg.catppuccin.cursors.enable) pkgs.bibata-cursors;
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
      catppuccin = {
        enable = lib.mkEnableOption "Enable Catppuccin Theme";
        cursors.enable = lib.mkEnableOption "Enable Catppuccin Cursor theme";
        gtk.enable = lib.mkEnableOption "Enable Catppuccin GTK theme";
      };
      gtk.enable = lib.mkEnableOption "Enable GTK Theme";
    };
  };
}
