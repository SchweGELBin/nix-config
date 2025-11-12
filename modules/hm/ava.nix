{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.ava;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; lib.optional cfg.glava.enable glava;
    programs.cava = {
      enable = cfg.cava.enable;
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
    ava = {
      enable = lib.mkEnableOption "Enable Audio Visualizers";
      cava.enable = lib.mkEnableOption "Enable Cava";
      glava.enable = lib.mkEnableOption "Enable GLava";
    };
  };
}
