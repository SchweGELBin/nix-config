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
    ./niri.nix
    ./packages.nix
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

  account.enable = lib.mkDefault false;
  alacritty.enable = lib.mkDefault false;
  android-sdk.enable = lib.mkDefault false;
  ava = {
    enable = lib.mkDefault false;
    cava.enable = lib.mkDefault true;
    glava.enable = lib.mkDefault true;
  };
  desktop.enable = lib.mkDefault true;
  direnv.enable = lib.mkDefault true;
  element.enable = lib.mkDefault false;
  fastfetch.enable = lib.mkDefault true;
  firefox = {
    enable = lib.mkDefault false;
    clean.enable = lib.mkDefault true;
    extensions = {
      behave.enable = lib.mkDefault true;
      darkreader.enable = lib.mkDefault true;
      firefox-color.enable = lib.mkDefault true;
      redirector.enable = lib.mkDefault true;
      skip-redirect.enable = lib.mkDefault true;
      stylus.enable = lib.mkDefault true;
      ublock-origin.enable = lib.mkDefault true;
    };
    harden.enable = lib.mkDefault true;
  };
  git.enable = lib.mkDefault true;
  helix.enable = lib.mkDefault true;
  hm-pkgs = {
    enable = lib.mkDefault true;
    home = {
      enable = lib.mkDefault false;
      wm = lib.mkDefault "hyprland";
    };
    phone.enable = lib.mkDefault false;
    server.enable = lib.mkDefault false;
    work.enable = lib.mkDefault false;
  };
  home.enable = lib.mkDefault true;
  hypr = {
    enable = lib.mkDefault false;
    idle.enable = lib.mkDefault true;
    land = {
      enable = lib.mkDefault true;
      dualSenseTouchpad.enable = lib.mkDefault false;
      forceBitdepth.enable = lib.mkDefault false;
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
  jellyfin-tui.enable = lib.mkDefault false;
  kitty.enable = lib.mkDefault false;
  mako.enable = lib.mkDefault false;
  mangohud.enable = lib.mkDefault false;
  mpv.enable = lib.mkDefault true;
  music.enable = lib.mkDefault false;
  niri.enable = lib.mkDefault false;
  rofi = {
    enable = lib.mkDefault false;
    modes = {
      combi.enable = lib.mkDefault false;
      drun.enable = lib.mkDefault true;
      filebrowser.enable = lib.mkDefault false;
      keys.enable = lib.mkDefault false;
      recursivebrowser.enable = lib.mkDefault false;
      run.enable = lib.mkDefault false;
      ssh.enable = lib.mkDefault false;
      window.enable = lib.mkDefault false;
    };
    plugins = {
      calc.enable = lib.mkDefault true;
      emoji.enable = lib.mkDefault true;
    };
  };
  scripts.enable = lib.mkDefault true;
  security.enable = lib.mkDefault true;
  tealdeer.enable = lib.mkDefault true;
  theme = {
    enable = lib.mkDefault true;
    catppuccin = {
      enable = lib.mkDefault true;
      cursors.enable = lib.mkDefault false;
      gtk.enable = lib.mkDefault false;
    };
    gtk.enable = lib.mkDefault false;
  };
  thunderbird.enable = lib.mkDefault false;
  vesktop.enable = lib.mkDefault false;
  waybar.enable = lib.mkDefault false;
  yt-dlp.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
}
