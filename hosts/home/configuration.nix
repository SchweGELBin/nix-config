let
  vars = import ../../modules/nix/vars.nix;
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
    boot.configs = 32;
  };
  sys-pkgs.home.enable = true;
}
