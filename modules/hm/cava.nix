{ config, lib, ... }:
{
  config = lib.mkIf config.cava.enable {
    programs.cava = {
      enable = true;
      settings = {
        smoothing.noise_reduction = 100;
      };
    };
  };

  options = {
    cava.enable = lib.mkEnableOption "Enable Cava";
  };
}
