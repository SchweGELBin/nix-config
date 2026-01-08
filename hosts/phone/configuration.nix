let
  vars = import ../../modules/vars.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix
  ];

  home-manager.users.${vars.user.name} = import ./home.nix;

  # Custom modules
  sys = {
    boot = {
      configs = 16;
      modules = {
        ntsync.enable = true;
        v4l2loopback.enable = true;
      };
      timeout = 3;
    };
    networking = {
      hostName = "phone";
      static = {
        enable = true;
        v4 = {
          enable = true;
          ip = "192.168.0.132";
        };
      };
    };
    pkgs.phone.enable = true;
  };
}
