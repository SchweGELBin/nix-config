{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.sys.services.greeter.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
          user = config.sys.users.name;
        };
      };
    };
  };

  options = {
    sys.services.greeter.enable = lib.mkEnableOption "Enable Greeter";
  };
}
