{ config, lib, ... }:
{
  config = lib.mkIf config.cava.enable {
    programs.cava = {
      enable = true;
      settings = {
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
