{ pkgs, ... }:
let
  vars = import ../nix/vars.nix;
in
{
  catppuccin = {
    enable = true;
    accent = vars.cat.accent;
    flavor = vars.cat.flavor;
    pointerCursor.enable = true;
  };

  gtk = {
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
}
