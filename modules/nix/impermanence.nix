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
        "/etc/nixos"
        "/var/lib"
      ];
      users.${vars.user.name} = {
        directories = [
          ".android"
          ".local/share"
          ".ssh"
          ".thunderbird"
          "Documents"
          "Downloads"
          "Git"
          "Media"
        ];
        files = [
          ".config/jellyfin-tui/config.yaml"
          ".config/sops/age/keys.txt"
        ];
      };
      hideMounts = true;
    };
  };

  options = {
    sys.impermanence.enable = lib.mkEnableOption "Enable Impermanence";
  };
}
