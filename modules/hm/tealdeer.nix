{ config, lib, ... }:
let
  cfg = config.tealdeer;
in
{
  config = lib.mkIf cfg.enable {
    programs.tealdeer = {
      enable = true;
      settings = {
        updates.auto_update = true;
      };
    };
  };

  options = {
    tealdeer.enable = lib.mkEnableOption "Enable Tealdeer";
  };
}
