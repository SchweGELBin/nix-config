{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.greeter;
  vars = import ../vars.nix;

  wm = if (config.sys.pkgs.home.wm == "hyprland") then "Hyprland" else config.sys.pkgs.home.wm;
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
