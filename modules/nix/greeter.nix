{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.greeter;
  vars = import ./vars.nix;

  wm =
    if config.sys.pkgs.home.hypr.enable then
      "Hyprland"
    else if config.sys.pkgs.home.niri.enable then
      "niri"
    else
      "";
in
{
  config = lib.mkIf cfg.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd ${wm}";
          user = vars.user.name;
        };
      };
    };
  };

  options = {
    sys.greeter.enable = lib.mkEnableOption "Enable Greeter";
  };
}
