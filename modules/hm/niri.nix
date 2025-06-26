{ config, lib, ... }:
let
  cfg = config.niri;
in
{
  config = lib.mkIf cfg.enable { };

  options = {
    niri.enable = lib.mkEnableOption "Enable Niri";
  };
}
