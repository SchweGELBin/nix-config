{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.impermanence;
in
{
  imports = [
    inputs.impermanence.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      directories = [
        "/etc/nixos"
        "/var/lib"
      ];
      hideMounts = true;
    };
  };

  options = {
    sys.impermanence.enable = lib.mkEnableOption "Enable Impermanence";
  };
}
