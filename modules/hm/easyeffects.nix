{ config, lib, ... }:
let
  cfg = config.easyeffects;
in
{
  config = lib.mkIf cfg.enable {
    services.easyeffects.enable = true;

    xdg.configFile = {
      "easyeffectsrc".text = ''
        [UiSettings]
        ColorScheme=Dracula
      '';
    };
  };

  options = {
    easyeffects.enable = lib.mkEnableOption "Enable Easy Effects";
  };
}
