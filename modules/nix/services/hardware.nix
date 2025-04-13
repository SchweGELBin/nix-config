{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.sys.services.hardware.enable {
    hardware = {
      graphics.enable = true;
      nvidia = {
        open = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };

    services = {
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
    sys.services.hardware.enable = lib.mkEnableOption "Enable Hardware";
  };
}
