{ config, pkgs, ... }:
{
  home.file.".bashrc" = {
    text = ''
      alias ff="fastfetch"
      alias changelog="conventional-changelog -p angular -i CHANGELOG.md -s -r 0"
    '';
  };
}
