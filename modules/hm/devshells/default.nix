{ config, lib, ... }:
let
  cfg = config.devshells;
  vars = import ../../nix/vars.nix;

  nixp = "use nix ${vars.user.config}/modules/hm/devshells";
in
{
  config = lib.mkIf cfg.enable {
    home.file = {
      "rust/bevy/.envrc" = lib.mkIf cfg.bevy.enable {
        text = "${nixp}/bevy.nix";
      };
    };
  };

  options = {
    devshells = {
      enable = lib.mkEnableOption "Enable Devshells";
      bevy.enable = lib.mkEnableOption "Enable Devshell: Bevy";
    };
  };
}
