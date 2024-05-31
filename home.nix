{ config, pkgs, inputs, ... }:

{
  home.username = "michi";
  home.homeDirectory = "/home/michi";
  programs.home-manager.enable = true;

  home.stateVersion = "24.05";

  imports = [
    ./modules/default.nix
  ];

  programs = {
    bat.enable = true;
    btop.enable = true;
    cava.enable = true;
    fuzzel.enable = true;
    git.enable = true;
    imv.enable = true;
    kitty.enable = true;
    fastfetch.enable = true;
    jq.enable = true;
    librewolf.enable = true;
    mangohud.enable = true;
    mpv.enable = true;
    obs-studio.enable = true;
    waybar = {
      enable = true;
      package = inputs.waybar.packages.${pkgs.system}.waybar;
    };
    wlogout.enable = true;
    yt-dlp.enable = true;
  };
}
