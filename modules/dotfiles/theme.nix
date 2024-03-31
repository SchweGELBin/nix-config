{ pkgs, ... }:
{
  gtk = {
    enable = true;
    #cursorTheme = { };
    iconTheme = {
      name = "Papirus";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin-Macchiato-Standard-Mauve-Dark";
      package = (pkgs.catppuccin-gtk.override{accents=["mauve"];size="standard";variant="macchiato";});
    };
  };

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
