{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.impermanence;
  vars = import ../vars.nix;

  conf = {
    directories = [
      vars.user.config
      "/var/lib"
      "/tmp"
    ];
    users.${vars.user.name} = {
      directories = [
        ".android"
        ".config"
        ".local/share"
        ".ssh"
        ".wine"
        "Documents"
        "Downloads"
        "Games"
        "Music"
        "Pictures"
        "Projects"
        "Videos"
      ];
    };
  };
in
{
  imports = [
    inputs.impermanence.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    environment.persistence."/persist" = conf // {
      hideMounts = true;
    };
  };

  options = {
    sys.impermanence = {
      enable = lib.mkEnableOption "Enable Impermanence";
      module = lib.mkOption {
        default = "impermanence";
        description = "Impermanence Module";
        type = lib.tzpes.enum [
          "impermanence"
          "preservation"
        ];
      };
    };
  };
}
