{ lib, ... }:
{
  config = lib.mkIf config.music.enable {
    home.file.".config/nix/music.list".text = ''
      https://piped.video/playlist?list=PL0PCz_ViBzWbmK6qG9CnTdvv5LntT32PM
      https://piped.video/playlist?list=PLHi2T2b45lpg_X7uHlNkk8kzycLvc1AAd 
      https://piped.video/playlist?list=PL37UZ2QfPUvz3k5mZNFZmjhLNTT-M5-Oa 
    '';
  };

  options = {
    music.enable = lib.mkEnableOption "Enable Music";
  };
}
