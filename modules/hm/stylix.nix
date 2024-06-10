{ config, pkgs, ... }:
{
  stylix = {
    enable = true;
    autoEnable = true;
    targets = {
      waybar.enable = false;
    };
  };
}
