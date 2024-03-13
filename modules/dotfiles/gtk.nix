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
      package = pkgs.catppuccin-gtk;
    };
  };
}
