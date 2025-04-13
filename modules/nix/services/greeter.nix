{
  config,
  lib,
  pkgs,
  ...
}:
let
  vars = import ../vars.nix;
in
{
  config = lib.mkIf config.sys.services.greeter.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
          user = vars.user.name;
        };
      };
    };
  };

  options = {
    sys.services.greeter.enable = lib.mkEnableOption "Enable Greeter";
  };
}
