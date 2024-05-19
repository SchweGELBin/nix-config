{ inputs, pkgs, ... }:
{
  gtk = {
    enable = true;
    theme.name = "adw-gtk3";
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".source =
  (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
    General.theme = "adw-gtk3";
  };
}
