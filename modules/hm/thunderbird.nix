{ config, lib, ... }:
let
  cfg = config.thunderbird;
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles.${vars.user.name}.isDefault = true;
    };
  };

  options = {
    thunderbird.enable = lib.mkEnableOption "Enable Thunderbird";
  };
}
