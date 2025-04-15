{ config, lib, ... }:
let
  cfg = config.fastfetch;
in
{
  config = lib.mkIf cfg.enable {
    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          source = "auto";
          padding = {
            right = 1;
          };
        };
        display = {
          size.binaryPrefix = "si";
          color = "blue";
          separator = "  ";
        };
        modules = [
          {
            type = "datetime";
            key = "Date";
            format = "{11}.{4}.{1} {9}";
          }
          {
            type = "datetime";
            key = "Time";
            format = "{14}:{18}:{20}";
          }
          "break"
          "os"
          "kernel"
          "initsystem"
          "break"
          "wm"
          "theme"
          "icons"
          "cursor"
          "font"
          "break"
          "terminal"
          "shell"
          "terminalfont"
          "break"
          "colors"
        ];
      };
    };
  };

  options = {
    fastfetch.enable = lib.mkEnableOption "Enable FastFetch";
  };
}
