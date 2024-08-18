{
  home.file.".config/kitty/cavabg.sh".text = "sleep 1 && cava";
  home.file.".config/kitty/kittybg.conf".text = "background_opacity 0";

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.7";
      font_size = "13.0";
    };
  };
}
