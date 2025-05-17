{ config, lib, ... }:
let
  cfg = config.home;
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    home = {
      homeDirectory = vars.user.home;
      stateVersion = vars.user.stateVersion;
      username = vars.user.name;
    };
  };

  options = {
    home.enable = lib.mkEnableOption "Enable Home";
  };
}
