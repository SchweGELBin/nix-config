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
      scripts = with pkgs; [
        mpvScripts.mpris
        mpvScripts.sponsorblock-minimal
      ];
    };
  };

  options = {
    mpv.enable = lib.mkEnableOption "Enable MPV";
  };
}
