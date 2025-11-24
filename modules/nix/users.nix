{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.users;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    users = {
      users.${vars.user.name} = {
        description = vars.user.name;
        extraGroups = [
          "docker"
          "input"
          "networkmanager"
          "wheel"
          "ydotool"
        ];
        initialPassword = "1234";
        isNormalUser = true;
        shell = pkgs.zsh;
      };
    };
  };

  options = {
    sys.users.enable = lib.mkEnableOption "Enable Users";
  };
}
