{ pkgs, config, ... }:
{
  home.file.".config/fuzzel/fuzzel.ini".text = ''
    [colors]
    background=1e1e2edd
    text=cdd6f4ff
    match=f38ba8ff
    selection=585b70ff
    selection-match=f38ba8ff
    selection-text=cdd6f4ff
    border=cba6f7ff
  '';
}
