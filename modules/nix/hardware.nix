{ config, lib, ... }:
let
  cfg = config.sys.hardware;
in
{
  config = lib.mkIf cfg.enable {
    hardware = {
      bluetooth.enable = cfg.bluetooth.enable;
      graphics.enable = true;
      nvidia = lib.mkIf cfg.nvidia.enable {
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };

    services = {
      avahi = {
        enable = cfg.printing.enable;
        nssmdns4 = true;
        openFirewall = true;
      };
      hardware.openrgb.enable = true;
      printing.enable = cfg.printing.enable;
      xserver = {
        enable = true;
        videoDrivers = lib.optional cfg.nvidia.enable "nvidia";
      };
    };
  };

  options = {
    sys.hardware = {
      enable = lib.mkEnableOption "Enable Hardware";
      bluetooth.enable = lib.mkEnableOption "Enable Bluetooth";
      nvidia.enable = lib.mkEnableOption "Enable NVidia";
      printing.enable = lib.mkEnableOption "Enable Printing";
    };
  };
}
