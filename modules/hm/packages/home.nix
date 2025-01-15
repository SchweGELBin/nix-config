{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  android = {
    composition = pkgs.androidenv.composeAndroidPackages {
      includeNDK = true;
      platformVersions = [ "35" ];
    };
    sdk = android.composition.androidsdk;
  };
in
{
  config = lib.mkIf config.hm-pkgs.home.enable {
    home = {
      packages = with pkgs; [
        android.sdk
        androidStudioPackages.dev
        audacity
        bibata-cursors
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
        inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
        inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
        inputs.hyprsysteminfo.packages.${pkgs.system}.hyprsysteminfo
        krita
        legendary-gl
        libnotify
        libreoffice-qt-fresh
        mako
        minetestclient
        nemo
        pavucontrol
        playerctl
        prismlauncher
        pulseaudio
        slurp
        wineWowPackages.stagingFull
        winetricks
        wl-clipboard
      ];

      sessionVariables = {
        ANDROID_HOME = "${android.sdk}/libexec/android-sdk";
        NDK_HOME = "$ANDROID_HOME/ndk-bundle";
      };
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
  };

  options = {
    hm-pkgs = {
      home.enable = lib.mkEnableOption "Enable Home Packages";
    };
  };
}
