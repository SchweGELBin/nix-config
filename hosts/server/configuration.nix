{
  config,
  inputs,
  pkgs,
  ...
}:

let
  vars = import ../../modules/nix/vars.nix;
in

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  boot.tmp.cleanOnBoot = true;

  networking.hostName = "nix";

  services.openssh.enable = true;

  system.stateVersion = "24.05";

  users.users.root.openssh.authorizedKeys.keys = [ vars.user.ssh ];

  zramSwap.enable = true;
}
