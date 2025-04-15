{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.fonts;
in
{
  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = true;
      fontconfig = {
        defaultFonts = {
          serif = [
            "DejaVu Serif"
            "Liberation Serif"
          ];
          sansSerif = [
            "DejaVu Sans"
            "FiraCode Nerd Font"
          ];
          monospace = [
            "FiraCode Nerd Font"
            "JetBrainsMono Nerd Font"
          ];
        };
      };
      packages = with pkgs; [
        nerd-fonts.dejavu-sans-mono
        nerd-fonts.fira-code
        nerd-fonts.jetbrains-mono
        nerd-fonts.liberation
      ];
    };
  };

  options = {
    sys.fonts.enable = lib.mkEnableOption "Enable Fonts";
  };
}
