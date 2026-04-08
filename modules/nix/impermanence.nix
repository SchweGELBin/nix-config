{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.impermanence;
  vars = import ../vars.nix;
in
{
  imports = [
    inputs.impermanence.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = {
      directories = [
        vars.user.config
        "/var/lib"
      ];
      hideMounts = true;
      users.${vars.user.name} = {
        directories = [
          ".android"
          ".config"
          ".local/share"
          ".ssh"
          ".thunderbird"
          ".wine"
          "Documents"
          "Downloads"
          "Games"
          "Git"
          "Media"
        ];
      };
    };
  };

  options = {
    sys.impermanence.enable = lib.mkEnableOption "Enable Impermanence";
  };
}
