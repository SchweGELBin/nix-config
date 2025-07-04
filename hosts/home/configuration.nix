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
      timeout = 3;
    };
    pkgs.home.enable = true;
    security.enable = false;
  };
}
