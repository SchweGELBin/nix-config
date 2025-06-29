{
  config,
  inputs,
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
      packages =
        with pkgs;
        [
          androidStudioPackages.dev
          audacity
          bitwarden-desktop
          blender
          (catppuccin.override {
            accent = vars.cat.accent;
            variant = vars.cat.flavor;
          })
          catppuccin-whiskers
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
          wl-clipboard
        ]
        ++ lib.optionals cfg.home.gaming.enable [
          (inputs.nix-gaming.packages.${pkgs.system}.rocket-league.override { enableBakkesmod = true; })
          inputs.nix-gaming.packages.${pkgs.system}.wine-tkg-ntsync
        ]
        ++ lib.optionals (cfg.home.gaming.enable == false) [
          wineWowPackages.stagingFull
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
