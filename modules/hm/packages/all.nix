{ pkgs, ... }:
{
  home.packages = with pkgs; [
    apksigner
    bash-language-server
    cmatrix
    file
    ffmpeg
    git-cliff
    imagemagick
    jdt-language-server
    kotlin-language-server
    lldb
    markdown-oxide
    marksman
    mdcat
    neo-cowsay
    nil
    nixfmt-rfc-style
    pipes-rs
    sops
    taplo
    toilet
    unzip
    zip
  ];

  programs = {
    bash.enable = true;
    bat.enable = true;
    btop.enable = true;
    git.enable = true;
    home-manager.enable = true;
    zsh.enable = true;
  };
}
