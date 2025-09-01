let
  vars = import ../../modules/vars.nix;
in
{
  imports = [
    ./hardware-configuration.nix
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
    gickup.enable = true;
    greeter.enable = false;
    hardware.enable = false;
    minecraft.enable = true;
    nginx.enable = true;
    networking = {
      hetzner = {
        enable = true;
        ipv4 = "78.47.17.130";
        ipv6 = "2a01:4f8:1c1c:7645::1";
      };
      hostName = vars.user.hostname.server;
    };
    nix.gc.enable = true;
    pkgs.server.enable = true;
    smoos.enable = true;
    sound.enable = false;
    wireguard.enable = true;
  };
}
