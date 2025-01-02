{ config, lib, ... }:
{
  config = lib.mkIf config.tealdeer.enable {
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
