{ config, lib, ... }:
let
  cfg = config.mako;
in
{
  config = lib.mkIf cfg.enable {
    services.mako = {
      enable = true;
      settings = {
        border-radius = 5;
        border-size = 2;
        default-timeout = 2000;
        layer = "overlay";
      };
    };
  };

  options = {
    mako.enable = lib.mkEnableOption "Enable Mako";
  };
}
