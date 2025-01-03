{
  inputs,
  pkgs,
  ...
}:
let
  vars = import ../../modules/nix/vars.nix;
in
{
  home = {
    homeDirectory = "${vars.user.home}";
    stateVersion = "${vars.user.stateVersion}";
    username = "${vars.user.name}";
  };

  imports = [
    ../../modules/hm
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  home.packages = with pkgs; [
    android-studio
    apksigner
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
    inputs.hyprsysteminfo.packages.${pkgs.system}.hyprsysteminfo
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
    sops
    taplo
    toilet
    unzip
    wineWowPackages.stagingFull
    wl-clipboard
    zip
  ];

  programs = {
    bat.enable = true;
    bash.enable = true;
    btop.enable = true;
    cava.enable = true;
    fuzzel.enable = true;
    git.enable = true;
    home-manager.enable = true;
    imv.enable = true;
    jq.enable = true;
    mangohud.enable = true;
    obs-studio.enable = true;
    wlogout.enable = true;
    yt-dlp.enable = true;
    zsh.enable = true;
  };

  # Custom modules
  alacritty.enable = true;
  devshells.enable = true;
  direnv.enable = true;
  firefox.enable = true;
  gtk.enable = true;
  hm-pkgs.home.enable = true;
  hypr.enable = true;
  kitty.enable = true;
  mako.enable = true;
  theme.gtk.enable = true;
  vesktop.enable = true;
  waybar.enable = true;
}
