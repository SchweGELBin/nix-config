{ lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./android-sdk.nix
    ./cava.nix
    ./direnv.nix
    ./fastfetch.nix
    ./firefox.nix
    ./git.nix
    ./helix.nix
    ./hypr.nix
    ./kitty.nix
    ./mako.nix
    ./mpv.nix
    ./music.nix
    ./packages
    ./scripts.nix
    ./tealdeer.nix
    ./theme.nix
    ./vesktop.nix
    ./waybar.nix
    ./zsh.nix
  ];

  alacritty.enable = lib.mkDefault false;
  android-sdk.enable = lib.mkDefault false;
  cava.enable = lib.mkDefault false;
  devshells = {
    enable = lib.mkDefault false;
    bevy.enable = lib.mkDefault false;
  };
  direnv.enable = lib.mkDefault false;
  fastfetch.enable = lib.mkDefault true;
  firefox.enable = lib.mkDefault false;
  git.enable = lib.mkDefault true;
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
