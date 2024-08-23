{
  home.file.".config/kitty/cavabg.sh".text = "sleep 1 && cava";
  home.file.".config/kitty/kittybg.conf".text = "background_opacity 0";

  programs.kitty = {
    enable = true;
    settings = {
      font_size = "13.0";
    };
  };
}
