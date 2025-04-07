{ pkgs, ... }:
{
  home.packages = with pkgs; [
    apksigner
    cmatrix
    file
    ffmpeg
    imagemagick
    mdcat
    neo-cowsay
    pipes-rs
    sops
    unzip
    wget
    zip
  ];

  programs = {
    bash.enable = true;
    bat.enable = true;
    btop.enable = true;
    git-cliff.enable = true;
    home-manager.enable = true;
    zsh.enable = true;
  };
}
