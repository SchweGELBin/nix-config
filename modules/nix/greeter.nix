{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.greeter;
  vars = import ./vars.nix;
in
{
  config = lib.mkIf cfg.enable {
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
    sys.greeter.enable = lib.mkEnableOption "Enable Greeter";
  };
}
