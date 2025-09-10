{ config, lib, ... }:
let
  cfg = config.sys.locale;
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
    services.xserver.xkb = {
      extraLayouts = {
        us_de = {
          description = "English (US with German Umlauts)";
          languages = [ "eng" ];
          symbolsFile = ./custom-keyboard;
        };
      };
      layout = "us_de";
      options = "caps:backspace";
    };
    time.timeZone = "Europe/Berlin";
  };

  options = {
    sys.locale.enable = lib.mkEnableOption "Enable Locale";
  };
}
