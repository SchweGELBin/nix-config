{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.impermanence;
  vars = import ../vars.nix;
in
{
  imports = [
    inputs.impermanence.homeManagerModules.default
  ];

  config = lib.mkIf cfg.enable {
    home.persistence."/persist${vars.user.home}" = {
      allowOther = true;
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
  };

  options = {
    impermanence.enable = lib.mkEnableOption "Enable Impermanence";
  };
}
