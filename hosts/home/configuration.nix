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
    boot = {
      configs = 32;
      modules = {
        ntsync.enable = true;
        v4l2loopback.enable = true;
      };
      timeout = 3;
    };
    disko.device = "/dev/nvme0n1";
    networking.static = {
      enable = true;
      v4 = {
        enable = true;
        ip = "192.168.0.123";
      };
    };
    nix.cuda.enable = true;
    pkgs.home.enable = true;
  };
}
