{ inputs, pkgs, ... }:
{
  home.packages = with pkgs; [
    android-studio
    audacity
    bibata-cursors
    blender
    exfat
    fusee-nano
    gedit
    gimp
    glfw
    godot_4
    grim
    inkscape
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    inputs.hyprsysteminfo.packages.${pkgs.system}.hyprsysteminfo
    krita
    legendary-gl
    libnotify
    libreoffice-qt-fresh
    mako
    minetestclient
    nemo
    papermc
    pavucontrol
    playerctl
    prismlauncher
    pulseaudio
    slurp
    wineWowPackages.stagingFull
    wl-clipboard
  ];

  programs = {
    cava.enable = true;
    fuzzel.enable = true;
    imv.enable = true;
    jq.enable = true;
    mangohud.enable = true;
    obs-studio.enable = true;
    wlogout.enable = true;
    yt-dlp.enable = true;
  };
}
