{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.mpv.enable {
    programs.mpv = {
      enable = true;
      scripts = with pkgs; [ mpvScripts.mpris ];
    };
  };

  options = {
    mpv.enable = lib.mkEnableOption "Enable MPV";
  };
}
