{ pkgs, config, ... }:
let
  vars = import ../nix/vars.nix;
in
{
  catppuccin = {
    enable = true;
    accent = vars.cat.accent;
    flavor = vars.cat.flavor;
  };

  gtk = {
    enable = true;
    catppuccin = {
      enable = true;
      accent = vars.cat.accent;
      cursor = {
        enable = true;
        accent = vars.cat.accent;
        flavor = vars.cat.flavor;
      };
      flavor = vars.cat.flavor;
      gnomeShellTheme = true;
      icon = {
        enable = true;
        accent = vars.cat.accent;
        flavor = vars.cat.flavor;
      };
      size = "standard";
      tweaks = [ "normal" ];
    };
  };

  programs = {
    waybar.catppuccin.mode = "createLink";
  };

  qt = {
    enable = true;
    style = {
      catppuccin = {
        enable = true;
        accent = vars.cat.accent;
        apply = true;
        flavor = vars.cat.flavor;
      };
      name = "kvantum";
    };
  };
}
