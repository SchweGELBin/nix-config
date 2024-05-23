{config, pkgs, ...}:
{
  stylix = {
    autoEnable = true;
    targets = {
      waybar.enable = false;
    };
  };
}
