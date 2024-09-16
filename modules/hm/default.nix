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
    ./nixvim.nix
    ./scripts
    ./theme.nix
    ./waybar.nix
    ./zsh.nix
  ];

  direnv.enable = lib.mkDefault false;
  fastfetch.enable = lib.mkDefault true;
  firefox.enable = lib.mkDefault false;
  helix.enable = lib.mkDefault true;
  hypr.enable = lib.mkDefault false;
  kitty.enable = lib.mkDefault false;
  mako.enable = lib.mkDefault false;
  music.enable = lib.mkDefault true;
  nixvim.enable = lib.mkDefault false;
  scripts.enable = lib.mkDefault true;
  theme = {
    enable = lib.mkDefault true;
    gtk.enable = lib.mkDefault false;
  };
  waybar.enable = lib.mkDefault false;
  zsh.enable = lib.mkDefault true;
}
