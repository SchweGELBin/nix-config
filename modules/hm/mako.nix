{ config, lib, ... }:
let
  cfg = config.mako;
in
{
  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      borderRadius = 5;
      borderSize = 2;
      defaultTimeout = 2000;
      layer = "overlay";
    };
  };

  options = {
    mako.enable = lib.mkEnableOption "Enable Mako";
  };
}
