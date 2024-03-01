{ pkgs, ... }:
{
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Macchiato-Standard-Mauve-Dark";
      package = pkgs.catppuccin-gtk;
    };
  };
}
