{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hm-pkgs;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        apksigner
        cmatrix
        file
        ffmpeg
        imagemagick
        nur.catspeak
        lsof
        mdcat
        neo-cowsay
        nix-tree
        pipes-rs
        pv
        pwgen
        sl
        sops
        toilet
        tree
        unzip
        wget
        zip
      ]
      ++ lib.optionals cfg.home.enable [
        androidStudioPackages.dev
        ardour
        audacity
        bitwarden-desktop
        blender
        (catppuccin.override {
          accent = vars.cat.accent;
          variant = vars.cat.flavor;
        })
        catppuccin-catwalk
        catppuccin-whiskers
        dolphin-emu
        easyeffects
        exiftool
        (fenix.combine [
          fenix.latest.toolchain
          fenix.targets.aarch64-linux-android.latest.rust-std
          fenix.targets.wasm32-unknown-unknown.latest.rust-std
        ])
        fusee-nano
        gedit
        gimp3
        godot
        grim
        inkscape
        nur.bible4tui
        kdePackages.kdenlive
        krita
        legendary-gl
        libnotify
        libreoffice-qt-fresh
        luanti
        mari0
        melonDS
        nemo
        nix-update
        nixpkgs-review
        nodejs
        pavucontrol
        pnpm
        prismlauncher
        pulseaudio
        qrencode
        ryubing
        slurp
        superTux
        superTuxKart
        theclicker
        wev
        winetricks
        wineWowPackages.stagingFull
        wl-clipboard
      ]
      ++ lib.optionals cfg.server.enable [
        wireguard-tools
      ];

    programs = {
      bash.enable = true;
      bat.enable = true;
      btop.enable = true;
      git-cliff.enable = true;
      home-manager.enable = true;
      vivid.enable = true;
      zsh.enable = true;
    }
    // lib.optionalAttrs cfg.home.enable {
      fuzzel.enable = true;
      imv.enable = true;
      jq.enable = true;
      obs-studio.enable = true;
      qutebrowser.enable = true;
      retroarch.enable = true;
      wlogout.enable = true;
    }
    // lib.optionalAttrs cfg.server.enable {
      htop.enable = true;
    };

    services = lib.optionalAttrs cfg.home.enable {
      playerctld.enable = true;
    };
  };

  options = {
    hm-pkgs = {
      enable = lib.mkEnableOption "Enable HM Packages";
      home.enable = lib.mkEnableOption "Enable HM Home Packages";
      server.enable = lib.mkEnableOption "Enable HM Server Packages";
    };
  };
}
