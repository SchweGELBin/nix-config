{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.rofi;
in
{
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      modes =
        lib.optional cfg.modes.combi.enable "combi"
        ++ lib.optional cfg.modes.drun.enable "drun"
        ++ lib.optional cfg.modes.filebrowser.enable "filebrowser"
        ++ lib.optional cfg.modes.keys.enable "keys"
        ++ lib.optional cfg.modes.recursivebrowser.enable "recursivebrowser"
        ++ lib.optional cfg.modes.run.enable "run"
        ++ lib.optional cfg.modes.ssh.enable "ssh"
        ++ lib.optional cfg.modes.window.enable "window"
        ++ lib.optional cfg.plugins.calc.enable "calc"
        ++ lib.optional cfg.plugins.emoji.enable "emoji";
      plugins =
        with pkgs;
        lib.optional cfg.plugins.calc.enable rofi-calc ++ lib.optional cfg.plugins.emoji.enable rofi-emoji;
    };
  };

  options = {
    rofi = {
      enable = lib.mkEnableOption "Enable Rofi";
      modes = {
        combi.enable = lib.mkEnableOption "Enable Rofi combi";
        drun.enable = lib.mkEnableOption "Enable Rofi drun";
        filebrowser.enable = lib.mkEnableOption "Enable Rofi filebrowser";
        keys.enable = lib.mkEnableOption "Enable Rofi keys";
        recursivebrowser.enable = lib.mkEnableOption "Enable Rofi recursivebrowser";
        run.enable = lib.mkEnableOption "Enable Rofi run";
        ssh.enable = lib.mkEnableOption "Enable Rofi ssh";
        window.enable = lib.mkEnableOption "Enable Rofi window";
      };
      plugins = {
        calc.enable = lib.mkEnableOption "Enable Rofi Calc";
        emoji.enable = lib.mkEnableOption "Enable Rofi Emojis";
      };
    };
  };
}
