{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.username = "michi";
  home.homeDirectory = "/home/michi";
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
    cargo
    cinnamon.nemo
    clippy
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
    nodePackages_latest.pnpm
    papermc
    pavucontrol
    pipes-rs
    prismlauncher
    pulseaudio
    rustc
    rustfmt
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
