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
        lib.optionals cfg.modes.combi.enable [ "combi" ]
        ++ lib.optionals cfg.modes.drun.enable [ "drun" ]
        ++ lib.optionals cfg.modes.filebrowser.enable [ "filebrowser" ]
        ++ lib.optionals cfg.modes.keys.enable [ "keys" ]
        ++ lib.optionals cfg.modes.recursivebrowser.enable [ "recursivebrowser" ]
        ++ lib.optionals cfg.modes.run.enable [ "run" ]
        ++ lib.optionals cfg.modes.ssh.enable [ "ssh" ]
        ++ lib.optionals cfg.modes.window.enable [ "window" ]
        ++ lib.optionals cfg.plugins.emoji.enable [ "emoji" ];
      plugins = with pkgs; lib.optionals cfg.emoji.enable [ rofi-emoji ];
    };
  };

  options = {
    rofi = {
      enable = lib.mkEnableOption "Enable Rofi";
      modes = {
        combi.enable = lib.mkEnableOption "Enable Rofi combi";
        drun.enable = lib.mkEnableOption "Enable Rofi  drun";
        filebrowser.enable = lib.mkEnableOption "Enable Rofi filebrowser";
        keys.enable = lib.mkEnableOption "Enable Rofi keys";
        recursivebrowser.enable = lib.mkEnableOption "Enable Rofi recursivebrowser";
        run.enable = lib.mkEnableOption "Enable Rofi run";
        ssh.enable = lib.mkEnableOption "Enable Rofi ssh";
        window.enable = lib.mkEnableOption "Enable Rofi window";
      };
      plugins = {
        emoji.enable = lib.mkEnableOption "Enable Rofi Emojis";
      };
    };
  };
}
