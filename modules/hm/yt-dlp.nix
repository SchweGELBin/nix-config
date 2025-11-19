{ config, lib, ... }:
let
  cfg = config.yt-dlp;
in
{
  config = lib.mkIf cfg.enable {
    programs.yt-dlp = {
      enable = true;
      settings = {
        convert-subs = "lrc";
        embed-metadata = true;
        embed-subs = true;
        embed-thumbnail = true;
        sub-langs = "en.*";
        write-subs = true;
      };
    };
  };

  options = {
    yt-dlp.enable = lib.mkEnableOption "Enable yt-dlp";
  };
}
