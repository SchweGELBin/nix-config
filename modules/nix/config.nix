{ pkgs, ... }:
let
  vars = import ../../modules/nix/vars.nix;
in
{
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment = {
    sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      NIXOS_INSTALL_BOOTLOADER = 1;
      NIXOS_OZONE_WL = 1;
    };
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

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk;
    };
    zsh.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    openssh.enable = true;
  };

  system = {
    stateVersion = "${vars.user.stateVersion}";
  };

  time = {
    timeZone = "Europe/Berlin";
  };
}
