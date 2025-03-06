{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.glava.enable {
    home = {
      file = {
        ".config/glava/circle" = {
          recursive = true;
          source = "${pkgs.glava}/etc/xdg/glava/circle";
        };
        ".config/glava/circle.glsl".text = ''
          #define AMPLIFY 150
          #define C_FILL 0
          #define C_LINE 1.5
          #define C_RADIUS 128
          #define C_SMOOTH 1
          #define INVERT 0
          #define OUTLINE #333333
          #define ROTATE (PI / 2)
          #request setgravitystep 6.0
          #request setsmoothfactor 0.01
        '';
        ".config/glava/rc.glsl".text = ''
          #request mod circle
          #request setdecorated false
          #request setgeometry 0 0 800 600
          #request setmaximized true
          #request setopacity "native"
          #request setxwintype "normal"
        '';
        ".config/glava/smooth_parameters.glsl".source =
          "${pkgs.glava}/etc/xdg/glava/smooth_parameters.glsl";
        ".config/glava/util" = {
          recursive = true;
          source = "${pkgs.glava}/etc/xdg/glava/util";
        };
      };
      packages = [ pkgs.glava ];
    };
  };

  options = {
    glava.enable = lib.mkEnableOption "Enable GLava";
  };
}
