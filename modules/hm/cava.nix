{ config, lib, ... }:
let
  cfg = config.cava;
in
{
  config = lib.mkIf cfg.enable {
    programs.cava = {
      enable = true;
      settings = {
        general = {
          sensitivity = 60;
        };
        output = {
          show_idle_bar_heads = 0;
        };
        smoothing = {
          monstercat = true;
          noise_reduction = 90;
          waves = true;
        };
      };
    };
  };

  options = {
    cava.enable = lib.mkEnableOption "Enable Cava";
  };
}
