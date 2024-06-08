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
    ./modules/hm/default.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.packages = with pkgs; [
    audacity
    blender
    cargo
    cinnamon.nemo
    clippy
    cmatrix
    fusee-nano
    gedit
    gimp
    glfw
    godot_4
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    krita
    libreoffice-qt-fresh
    minetestclient
    neo-cowsay
    nodePackages_latest.pnpm
    papermc
    papirus-icon-theme
    pipes-rs
    prismlauncher
    pulseaudio
    rustc
    rustfmt
    toilet
    vesktop
  ];

  programs = {
    bat.enable = true;
    bash.enable = true;
    btop.enable = true;
    cava.enable = true;
    fuzzel.enable = true;
    git.enable = true;
    imv.enable = true;
    kitty.enable = true;
    jq.enable = true;
    mangohud.enable = true;
    mpv.enable = true;
    obs-studio.enable = true;
    waybar = {
      enable = true;
      package = inputs.waybar.packages.${pkgs.system}.waybar;
    };
    wlogout.enable = true;
    yt-dlp.enable = true;
    zsh.enable = true;
  };
}
