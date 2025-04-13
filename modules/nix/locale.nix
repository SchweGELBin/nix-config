{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.sys.locale.enable {
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
      stateVersion = config.sys.locale.stateVersion;
    };

    time = {
      timeZone = "Europe/Berlin";
    };
  };

  options = {
    sys.locale = {
      enable = lib.mkEnableOption "Enable Locale";
      stateVersion = lib.mkOption {
        description = "Set StateVersion";
        type = lib.types.str;
      };
    };
  };
}
