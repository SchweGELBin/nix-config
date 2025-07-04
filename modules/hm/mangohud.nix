{ config, lib, ... }:
let
  cfg = config.mangohud;
in
{
  config = lib.mkIf cfg.enable {
    programs.mangohud = {
      enable = true;
      enableSessionWide = true;
    };
  };

  options = {
    mangohud.enable = lib.mkEnableOption "Enable MangoHud";
  };
}
