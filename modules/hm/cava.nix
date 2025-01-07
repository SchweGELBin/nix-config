{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.cava.enable {
    programs.cava = {
      enable = true;
      package = (pkgs.cava.override { withSDL2 = true; });
      settings = {
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
