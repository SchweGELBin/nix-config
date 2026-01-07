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
    catppuccin.enable = false;
    fonts.enable = false;
    greeter.enable = false;
    hardware.enable = false;
    security.enable = false;
    sound.enable = false;
    wireguard.enable = false;
  };
}
