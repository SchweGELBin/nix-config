{ pkgs, ... }:
{
  qt = {
    enable = true;
    platformTheme = "qtct";
    style.name = "kvantum";
  }; 

  home.packages = with pkgs; [
    (catppuccin.override{accent="mauve";variant="macchiato";})
  ];

  xdg.configFile."Kvantum/kvantum.kvconfig".source =
  (pkgs.formats.ini {}).generate "kvantum.kvconfig" {
    General.theme = "Catppuccin-Macchiato-Mauve";
  };
}
