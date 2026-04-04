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
      extraModprobeConfig = lib.optionalString cfg.modules.v4l2loopback.enable ''
        options v4l2loopback exclusive_caps=1 devices=3 video_nr=1,2,3 card_label="OBS Cam,Handy Screen,Handy Cam"
      '';
      extraModulePackages =
        with config.boot.kernelPackages;
        lib.optional cfg.modules.v4l2loopback.enable v4l2loopback;
      kernelModules =
        lib.optional cfg.modules.ntsync.enable "ntsync"
        ++ lib.optional cfg.modules.v4l2loopback.enable "v4l2loopback";
      kernelPackages = pkgs.linuxPackages_latest;
      loader = {
        efi.canTouchEfiVariables = false;
        grub = {
          enable = cfg.grub.enable;
          configurationLimit = cfg.configs;
          device = "nodev";
          efiInstallAsRemovable = true;
          efiSupport = true;
          useOSProber = true;
        };
        timeout = cfg.timeout;
      };
      tmp.cleanOnBoot = true;
    };
    zramSwap.enable = true;
  };

  options = {
    sys.boot = {
      enable = lib.mkEnableOption "Enable Boot";
      configs = lib.mkOption {
        default = 2;
        description = "Configuration Limit";
        type = lib.types.int;
      };
      grub.enable = lib.mkEnableOption "Enable GRUB" // {
        default = true;
      };
      modules = {
        ntsync.enable = lib.mkEnableOption "Enable NTSync";
        v4l2loopback.enable = lib.mkEnableOption "Enable v4l2loopback";
      };
      timeout = lib.mkOption {
        default = 0;
        description = "Bootloader Timeout";
        type = lib.types.int;
      };
    };
  };
}
