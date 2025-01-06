{ lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./cava.nix
    ./direnv.nix
    ./fastfetch.nix
    ./firefox.nix
    ./helix.nix
    ./hypr.nix
    ./kitty.nix
    ./mako.nix
    ./mpv.nix
    ./music.nix
    ./packages
    ./scripts
    ./tealdeer.nix
    ./theme.nix
    ./vesktop.nix
    ./waybar.nix
    ./zsh.nix
  ];

  alacritty.enable = lib.mkDefault false;
  cava.enable = lib.mkDefault false;
  devshells = {
    enable = lib.mkDefault false;
    android.enable = lib.mkDefault true;
    rust = {
      enable = lib.mkDefault true;
      dioxus.enable = lib.mkDefault false;
      egui.enable = lib.mkDefault false;
      slint.enable = lib.mkDefault false;
      tauri.enable = lib.mkDefault false;
    };
  };
  direnv.enable = lib.mkDefault false;
  fastfetch.enable = lib.mkDefault true;
  firefox.enable = lib.mkDefault false;
  helix.enable = lib.mkDefault true;
  hypr.enable = lib.mkDefault false;
  kitty.enable = lib.mkDefault false;
  mako.enable = lib.mkDefault false;
  mpv.enable = lib.mkDefault true;
  music.enable = lib.mkDefault true;
  scripts.enable = lib.mkDefault true;
  tealdeer.enable = lib.mkDefault true;
  theme = {
    enable = lib.mkDefault true;
    gtk.enable = lib.mkDefault false;
  };
  vesktop.enable = lib.mkDefault false;
  waybar.enable = lib.mkDefault false;
  zsh.enable = lib.mkDefault true;
}
