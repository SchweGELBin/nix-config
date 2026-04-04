{ lib, ... }:
{
  imports = [
    ./account.nix
    ./alacritty.nix
    ./android-sdk.nix
    ./ava.nix
    ./direnv.nix
    ./desktop.nix
    ./element.nix
    ./fastfetch.nix
    ./firefox.nix
    ./git.nix
    ./helix.nix
    ./home.nix
    ./hypr.nix
    ./jellyfin-tui.nix
    ./kitty.nix
    ./mako.nix
    ./mangohud.nix
    ./mpv.nix
    ./music.nix
    ./packages.nix
    ./retroarch.nix
    ./rofi.nix
    ./scripts.nix
    ./security.nix
    ./tealdeer.nix
    ./theme.nix
    ./thunderbird.nix
    ./vesktop.nix
    ./waybar.nix
    ./yt-dlp.nix
    ./zsh.nix
  ];

  direnv.enable = lib.mkDefault true;
  fastfetch.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  helix.enable = lib.mkDefault true;
  hm-pkgs.enable = lib.mkDefault true;
  home.enable = lib.mkDefault true;
  mpv.enable = lib.mkDefault true;
  scripts.enable = lib.mkDefault true;
  security.enable = lib.mkDefault true;
  tealdeer.enable = lib.mkDefault true;
  theme.enable = lib.mkDefault true;
  yt-dlp.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
}
