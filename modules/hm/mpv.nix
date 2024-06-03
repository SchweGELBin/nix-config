{ config, pkgs, ... }:
{
  home.file.".config/mpv/mpv.conf".text = ''
    keep-open=yes
  '';
}
