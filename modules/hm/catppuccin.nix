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
      cursor.enable = true;
      icon.enable = true;
      size = "standard";
      tweaks = [ "normal" ];
    };
  };

  qt = {
    enable = true;
    style.name = "kvantum";
  };
}
