{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.disko;
in
{
  imports = [
    ./config.nix
    inputs.disko.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    disko.devices.disk.main.device = lib.mkForce cfg.device;
    fileSystems = {
      "/persist".neededForBoot = true;
      "/var/log".neededForBoot = true;
    };
  };

  options = {
    sys.disko = {
      enable = lib.mkEnableOption "Enable Disko";
      device = lib.mkOption {
        description = "Disko Device";
        type = lib.types.str;
      };
    };
  };
}
