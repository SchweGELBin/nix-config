{ config, lib, pkgs, ... }:
{
  home.file.".config/prettier/.prettierrc.json".text = ''
    {
      "useTabs": false,
      "tabWidth": 4,
      "printWidth": 80,
      "endOfLine": "lf"
    }
  '';
}
