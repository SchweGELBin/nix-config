{ lib, ... }:
{
  imports = [
    ./alacritty.nix
    ./android-sdk.nix
    ./cava.nix
    ./direnv.nix
    ./devshells
    ./element.nix
    ./fastfetch.nix
    ./firefox.nix
    ./git.nix
    ./glava.nix
    ./helix.nix
    ./home.nix
    ./hypr.nix
    ./kitty.nix
    ./mako.nix
    ./mangohud.nix
    ./mpv.nix
    ./music.nix
    ./niri.nix
    ./packages
    ./scripts.nix
    ./tealdeer.nix
    ./theme.nix
    ./thunderbird.nix
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
  element.enable = lib.mkDefault false;
  fastfetch.enable = lib.mkDefault true;
  firefox.enable = lib.mkDefault false;
  git.enable = lib.mkDefault true;
  glava.enable = lib.mkDefault false;
  helix.enable = lib.mkDefault true;
  hm-pkgs = {
    enable = lib.mkDefault true;
    home.enable = lib.mkDefault false;
    server.enable = lib.mkDefault false;
  };
  home.enable = lib.mkDefault true;
  hypr = {
    enable = lib.mkDefault false;
    idle.enable = lib.mkDefault true;
    land = {
      enable = lib.mkDefault true;
      plugins = {
          enable = lib.mkDefault true;
          borders-plus-plus.enable = lib.mkDefault false;
          csgo-vulkan-fix.enable = lib.mkDefault false;
          hyprbars.enable = lib.mkDefault false;
          hyprexpo.enable = lib.mkDefault true;
          hyprfocus.enable = lib.mkDefault false;
          hyprscrolling.enable = lib.mkDefault false;
          hyprtrails.enable = lib.mkDefault true;
          hyprwinwrap.enable = lib.mkDefault true;
          xtra-dispatchers.enable = lib.mkDefault false;
        };
    };
    lock.enable = lib.mkDefault true;
    paper.enable = lib.mkDefault true;
    picker.enable = lib.mkDefault true;
  };
  kitty.enable = lib.mkDefault false;
  mako.enable = lib.mkDefault false;
  mangohud.enable = lib.mkDefault false;
  mpv.enable = lib.mkDefault true;
  music.enable = lib.mkDefault true;
  niri.enable = lib.mkDefault false;
  scripts.enable = lib.mkDefault true;
  tealdeer.enable = lib.mkDefault true;
  theme = {
    enable = lib.mkDefault true;
    catppuccin = {
      enable = lib.mkDefault true;
      cursors.enable = lib.mkDefault false;
    };
    gtk.enable = lib.mkDefault false;
  };
  thunderbird.enable = lib.mkDefault false;
  vesktop.enable = lib.mkDefault false;
  waybar.enable = lib.mkDefault false;
  zsh.enable = lib.mkDefault true;
}
