{config, inputs, ...}:
{
  programs.kitty.enable = true;
  programs.kitty.settings = {
    background_opacity = "0.7";
    font_size = "13.0";
    font_family = "Fira Code SemiBold";

    # Colors
    # Black
    color0 = "#${config.colorScheme.palette.base00}";
    color8 = "#${config.colorScheme.palette.base00}";
    # Red
    color1 = "#${config.colorScheme.palette.base08}";
    color9 = "#${config.colorScheme.palette.base08}";
    # Green
    color2 = "#${config.colorScheme.palette.base0B}";
    color10 = "#${config.colorScheme.palette.base0B}";
    # Yellow
    color3 = "#${config.colorScheme.palette.base0A}";
    color11 = "#${config.colorScheme.palette.base0A}";
    # Blue
    color4 = "#${config.colorScheme.palette.base0D}";
    color12 = "#${config.colorScheme.palette.base0D}";
    # Magenta
    color5 = "#${config.colorScheme.palette.base0E}";
    color13 = "#${config.colorScheme.palette.base0E}";
    # Cyan
    color6 = "#${config.colorScheme.palette.base0C}";
    color14 = "#${config.colorScheme.palette.base0C}";
    # White
    color7 = "#${config.colorScheme.palette.base05}";
    color15 = "#${config.colorScheme.palette.base05}";

    # Marks
    # Light Steel Blue
    mark1_foreground = "black";
    mark1_background = "#${config.colorScheme.palette.base07}";
    # Beige
    mark2_foreground = "black";
    mark2_background = "#${config.colorScheme.palette.base0F}";
    # Violet
    mark3_foreground = "black";
    mark3_background = "#${config.colorScheme.palette.base09}";
  };
}
