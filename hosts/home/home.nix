{
  inputs,
  pkgs,
  ...
}:
let
  vars = import ../../modules/nix/vars.nix;
in
{
  home.username = "${vars.user.name}";
  home.homeDirectory = "${vars.user.home}";
  programs.home-manager.enable = true;

  home = {
    stateVersion = "24.11";
  };

  imports = [
    ../../modules/hm
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  home.packages = with pkgs; [
    android-studio
    audacity
    bash-language-server
    bibata-cursors
    blender
    cmatrix
    exfat
    ffmpeg
    file
    fusee-nano
    gedit
    gimp
    git-cliff
    glfw
    godot_4
    grim
    imagemagick
    inkscape
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    jdt-language-server
    kotlin-language-server
    krita
    legendary-gl
    libnotify
    libreoffice-qt-fresh
    lldb
    mako
    markdown-oxide
    marksman
    mdcat
    minetestclient
    nemo
    neo-cowsay
    nil
    nixfmt-rfc-style
    papermc
    papirus-icon-theme
    pavucontrol
    pipes-rs
    playerctl
    prismlauncher
    pulseaudio
    slurp
    taplo
    toilet
    unzip
    vesktop
    wineWowPackages.stagingFull
    wl-clipboard
  ];

  programs = {
    bat.enable = true;
    bash.enable = true;
    btop.enable = true;
    cava.enable = true;
    fuzzel.enable = true;
    git.enable = true;
    imv.enable = true;
    jq.enable = true;
    mangohud.enable = true;
    obs-studio.enable = true;
    wlogout.enable = true;
    yt-dlp.enable = true;
    zsh.enable = true;
  };

  # Custom modules
  devshells = {
    enable = true;
  };
  direnv.enable = true;
  firefox.enable = true;
  hypr.enable = true;
  kitty.enable = true;
  mako.enable = true;
  theme.gtk.enable = true;
  waybar.enable = true;
}
