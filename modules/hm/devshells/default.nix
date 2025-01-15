{ config, lib, ... }:
let
  vars = import ../../nix/vars.nix;
  nixp = "use nix ${vars.user.config}/modules/hm/devshells";

  cfg = config.devshells;
  enable = cfg.enable;

  bevy = cfg.bevy.enable;
in
{
  config = lib.mkIf enable {
    home.file = {
      "rust/bevy/.envrc" = lib.mkIf bevy {
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
