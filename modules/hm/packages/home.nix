{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hm-pkgs;
  enable = cfg.enable && cfg.home.enable;
in
{
  config = lib.mkIf enable {
    home = {
      packages = with pkgs; [
        androidStudioPackages.dev
        audacity
        blender
        exfat
        (fenix.combine [
          fenix.latest.toolchain
          fenix.targets.aarch64-linux-android.latest.rust-std
          fenix.targets.wasm32-unknown-unknown.latest.rust-std
        ])
        fusee-nano
        gedit
        gimp
        glfw
        grim
        hyprpicker
        inkscape
        krita
        legendary-gl
        libnotify
        libreoffice-qt-fresh
        minetestclient
        nemo
        pavucontrol
        prismlauncher
        pulseaudio
        sl
        slurp
        toilet
        wev
        wineWowPackages.stagingFull
        winetricks
        wl-clipboard
      ];
    };

    programs = {
      fuzzel.enable = true;
      imv.enable = true;
      jq.enable = true;
      mangohud.enable = true;
      obs-studio.enable = true;
      wlogout.enable = true;
      yt-dlp.enable = true;
    };

    services = {
      playerctld.enable = true;
    };
  };
}
