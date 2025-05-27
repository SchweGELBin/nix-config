{ config, lib, ... }:
let
  cfg = config.sys.hardware;
in
{
  config = lib.mkIf cfg.enable {
    hardware = {
      graphics.enable = true;
      nvidia = {
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };

    services = {
      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
      hardware.openrgb.enable = true;
      printing.enable = true;
      xserver = {
        enable = true;
        exportConfiguration = true;
        videoDrivers = [ "nvidia" ];
      };
    };
  };

  options = {
    sys.hardware.enable = lib.mkEnableOption "Enable Hardware";
  };
}
