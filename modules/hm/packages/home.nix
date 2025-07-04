{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hm-pkgs;
  enable = cfg.enable && cfg.home.enable;

  vars = import ../../nix/vars.nix;
in
{
  config = lib.mkIf enable {
    home = {
      packages = with pkgs; [
        androidStudioPackages.dev
        audacity
        bitwarden-desktop
        blender
        (catppuccin.override {
          accent = vars.cat.accent;
          variant = vars.cat.flavor;
        })
        catppuccin-whiskers
        devtoolbox
        exfat
        (fenix.combine [
          fenix.latest.toolchain
          fenix.targets.aarch64-linux-android.latest.rust-std
          fenix.targets.wasm32-unknown-unknown.latest.rust-std
        ])
        fusee-nano
        gedit
        gimp3
        glfw
        grim
        inkscape
        jellyfin-tui
        krita
        legendary-gl
        libnotify
        libreoffice-qt-fresh
        minetestclient
        nemo
        nix-update
        nixpkgs-review
        pavucontrol
        prismlauncher
        pulseaudio
        sl
        slurp
        toilet
        wev
        winetricks
        wineWowPackages.stagingFull
        wl-clipboard
      ];
    };

    programs = {
      fuzzel.enable = true;
      imv.enable = true;
      jq.enable = true;
      obs-studio.enable = true;
      wlogout.enable = true;
      yt-dlp.enable = true;
    };

    services = {
      playerctld.enable = true;
    };
  };
}
