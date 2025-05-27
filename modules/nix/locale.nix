{ config, lib, ... }:
let
  cfg = config.sys.locale;
  vars = import ./vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true;
    };
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEADUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
      };
    };

    system = {
      stateVersion = vars.user.stateVersion;
    };

    time = {
      timeZone = "Europe/Berlin";
    };
  };

  options = {
    sys.locale.enable = lib.mkEnableOption "Enable Locale";
  };
}
