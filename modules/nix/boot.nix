{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.boot;
in
{
  config = lib.mkIf cfg.enable {
    boot = {
      loader = {
        efi.canTouchEfiVariables = false;
        grub = {
          enable = true;
          configurationLimit = cfg.configs;
          device = "nodev";
          efiInstallAsRemovable = true;
          efiSupport = true;
          useOSProber = true;
        };
        timeout = cfg.timeout;
      };
      kernelPackages = pkgs.linuxPackages_latest;
      tmp.cleanOnBoot = true;
    };
    zramSwap.enable = true;
  };

  options = {
    sys.boot = {
      enable = lib.mkEnableOption "Enable Boot";
      configs = lib.mkOption {
        description = "Configuration Limit";
        type = lib.types.int;
      };
      timeout = lib.mkOption {
        description = "Bootloader Timeout";
        type = lib.types.int;
      };
    };
  };
}
