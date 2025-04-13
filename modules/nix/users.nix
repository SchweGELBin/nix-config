{
  config,
  lib,
  pkgs,
  ...
}:
let
  vars = import ./vars.nix;
in
{
  config = lib.mkIf config.sys.users.enable {
    users = {
      users.${vars.user.name} = {
        description = vars.user.name;
        extraGroups = [
          "docker"
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
