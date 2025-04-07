{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.hm-pkgs.home.enable {
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
        godot_4
        grim
        inkscape
        inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
        inputs.hyprsysteminfo.packages.${pkgs.system}.hyprsysteminfo
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

  options = {
    hm-pkgs = {
      home.enable = lib.mkEnableOption "Enable Home Packages";
    };
  };
}
