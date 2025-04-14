let
  vars = import ../../modules/nix/vars.nix;
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
    networking = {
      gateway.enable = false;
      hostName = vars.user.hostname.server;
    };
    nix.gc.enable = true;
    services = {
      greeter.enable = false;
      hardware.enable = false;
      minecraft.enable = true;
      nginx.enable = true;
      smoos.enable = true;
      sound.enable = false;
      wireguard.enable = true;
    };
  };
  sys-pkgs.server.enable = true;
}
