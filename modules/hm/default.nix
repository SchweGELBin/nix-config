{ lib, ... }:
{
  imports = [
    ./direnv.nix
    ./fastfetch.nix
    ./firefox.nix
    ./helix.nix
    ./hypr.nix
    ./kitty.nix
    ./mako.nix
    ./music.nix
    ./scripts
    ./theme.nix
    ./waybar.nix
    ./zsh.nix
  ];

  devshells = {
    enable = lib.mkDefault true;
    android.enable = lib.mkDefault true;
    rust = {
      enable = lib.mkDefault true;
      dioxus.enable = lib.mkDefault false;
      egui.enable = lib.mkDefault false;
      tauri.enable = lib.mkDefault false;
    };
  };
  direnv.enable = lib.mkDefault true;
  fastfetch.enable = lib.mkDefault true;
  firefox.enable = lib.mkDefault false;
  helix.enable = lib.mkDefault true;
  hypr.enable = lib.mkDefault false;
  kitty.enable = lib.mkDefault false;
  mako.enable = lib.mkDefault false;
  music.enable = lib.mkDefault true;
  scripts.enable = lib.mkDefault true;
  theme = {
    enable = lib.mkDefault true;
    gtk.enable = lib.mkDefault false;
  };
  waybar.enable = lib.mkDefault false;
  zsh.enable = lib.mkDefault true;
}
