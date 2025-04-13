{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.sys.boot.enable {
    boot = {
      loader = {
        efi.canTouchEfiVariables = false;
        grub = {
          enable = true;
          configurationLimit = config.sys.boot.configs;
          device = "nodev";
          efiInstallAsRemovable = true;
          efiSupport = true;
          useOSProber = true;
        };
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
    };
  };
}
