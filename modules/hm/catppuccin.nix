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
    catppuccin = {
      enable = true;
      icon.enable = true;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };
}
