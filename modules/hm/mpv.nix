{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mpv;
in
{
  config = lib.mkIf cfg.enable {
    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        mpris
        sponsorblock-minimal
      ];
    };
  };

  options = {
    mpv.enable = lib.mkEnableOption "Enable MPV";
  };
}
