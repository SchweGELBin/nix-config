{ config, lib, ... }:
let
  cfg = config.music;
in
{
  config = lib.mkIf cfg.enable {
    xdg.configFile."Media/Music/play.list".text = ''
      https://www.youtube.com/playlist?list=PL0PCz_ViBzWbmK6qG9CnTdvv5LntT32PM
      https://www.youtube.com/playlist?list=PLHi2T2b45lpg_X7uHlNkk8kzycLvc1AAd
      https://www.youtube.com/playlist?list=PL37UZ2QfPUvz3k5mZNFZmjhLNTT-M5-Oa
    '';
  };

  options = {
    music.enable = lib.mkEnableOption "Enable Music";
  };
}
