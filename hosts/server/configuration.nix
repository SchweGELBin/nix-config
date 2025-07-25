let
  vars = import ../../modules/vars.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ../../modules/nix
  ];

  home-manager = {
    users = {
      ${vars.user.name} = import ./home.nix;
    };
  };

  # Custom modules
  sys = {
    fonts.enable = false;
    greeter.enable = false;
    hardware.enable = false;
    minecraft.enable = true;
    nginx = {
      enable = true;
      immich.enable = false;
      nextcloud.enable = false;
      zipline.enable = false;
    };
    networking = {
      gateway.enable = false;
      hostName = vars.user.hostname.server;
    };
    nix.gc.enable = true;
    pkgs.server.enable = true;
    smoos.enable = true;
    sound.enable = false;
    wireguard.enable = true;
  };
}
