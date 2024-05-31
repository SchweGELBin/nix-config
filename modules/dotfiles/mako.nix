{ pkgs, config, ... }:
{
  services.mako = {
    enable = true;
    borderRadius = 5;
    borderSize = 2;
    layer = "overlay";
  };
}
