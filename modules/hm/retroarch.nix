{ config, lib, ... }:
let
  cfg = config.retroarch;
in
{
  config = lib.mkIf cfg.enable {
    programs.retroarch = {
      enable = true;
    };
  };

  options = {
    retroarch.enable = lib.mkEnableOption "Enable RetroArch";
  };
}
