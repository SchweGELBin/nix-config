{ inputs, pkgs, ... }:
let
  vars = import ./modules/nix/vars.nix;
in
{
  home.username = "${vars.user.name}";
  home.homeDirectory = "${vars.user.home}";
  programs.home-manager.enable = true;

  home.stateVersion = "24.11";

  imports = [
    ./modules/hm
    inputs.nixvim.homeManagerModules.nixvim
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  home.packages = with pkgs; [
    audacity
    bibata-cursors
    blender
    cinnamon.nemo
    cmatrix
    ffmpeg
    fusee-nano
    gedit
    gimp
    glfw
    godot_4
    grim
    imagemagick
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    krita
    legendary-gl
    libnotify
    libreoffice-qt-fresh
    mako
    minetestclient
    neo-cowsay
    nixfmt-rfc-style
    papermc
    papirus-icon-theme
    pavucontrol
    pipes-rs
    prismlauncher
    pulseaudio
    slurp
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
    mpv.enable = true;
    obs-studio.enable = true;
    wlogout.enable = true;
    yt-dlp.enable = true;
    zsh.enable = true;
  };
}
