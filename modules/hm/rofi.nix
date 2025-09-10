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
      modes = [
        "combi"
        "drun"
        "filebrowser"
        "keys"
        "recursivebrowser"
        "run"
        "ssh"
        "window"
      ]
      ++ lib.optionals cfg.emoji.enable [ "emoji" ];
      plugins = with pkgs; lib.optionals cfg.emoji.enable [ rofi-emoji ];
    };
  };

  options = {
    rofi = {
      enable = lib.mkEnableOption "Enable Rofi";
      emoji.enable = lib.mkEnableOption "Enable Rofi Emojis";
    };
  };
}
