{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.sys.environment.enable {
    environment.sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      NIXOS_INSTALL_BOOTLOADER = 1;
      NIXOS_OZONE_WL = 1;
    };
  };

  options = {
    sys.environment.enable = lib.mkEnableOption "Enable Environment";
  };
}
