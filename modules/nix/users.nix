{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.sys.users.enable {
    users = {
      users.${config.sys.users.name} = {
        description = "${config.sys.users.name}";
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
    sys.users = {
      enable = lib.mkEnableOption "Enable Users";
      name = lib.mkOption {
        description = "User Name";
        type = lib.types.str;
      };
    };
  };
}
