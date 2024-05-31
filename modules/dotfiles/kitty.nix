{ config, lib, inputs, ... }:
with config.lib.stylix.colors.withHashtag;
{
  programs.kitty.enable = true;
  programs.kitty.settings = {
    font_size = "13.0";
    font_family = "Fira Code SemiBold";

    # Colors
    # Black
    color0 = "${base00}";
    color8 = "${base08}";
    # Red
    color1 = "${base01}";
    color9 = "${base09}";
    # Green
    color2 = "${base02}";
    color10 = "${base0A}";
    # Yellow
    color3 = "${base03}";
    color11 = "${base0B}";
    # Blue
    color4 = "${base04}";
    color12 = "${base0C}";
    # Magenta
    color5 = "${base05}";
    color13 = "${base0D}";
    # Cyan
    color6 = "${base06}";
    color14 = "${base0E}";
    # White
    color7 = "${base07}";
    color15 = "${base0F}";

    # Marks
    # Light Steel Blue
    mark1_foreground = "black";
    mark1_background = "#98d3cb";
    # Beige
    mark2_foreground = "black";
    mark2_background = "#f2dcd3";
    # Violet
    mark3_foreground = "black";
    mark3_background = "#f274bc";
  };
}
