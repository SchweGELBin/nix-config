{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.pkgs;
in
{
  config = lib.mkIf cfg.enable {
    environment.systemPackages =
      with pkgs;
      [
        cachix
        cmake
        gcc
      ]
      ++ lib.optionals cfg.home.enable [ ]
      ++ lib.optionals cfg.server.enable [ ];

    programs = {
      java.enable = true;
      nix-ld.enable = true;
      zsh.enable = true;
    }
    // lib.optionalAttrs cfg.home.enable {
      gamemode.enable = true;
      hyprland = {
        enable = (cfg.home.wm == "hyprland");
        xwayland.enable = true;
      };
      hyprlock.enable = (cfg.home.wm == "hyprland");
      niri.enable = (cfg.home.wm == "niri");
      ssh = {
        enableAskPassword = false;
        startAgent = (cfg.home.wm == "hyprland");
      };
      steam = {
        enable = true;
        gamescopeSession.enable = true;
      };
      ydotool.enable = true;
    }
    // lib.optionalAttrs cfg.server.enable { };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    services = {
      openssh.enable = true;
    };

    xdg.portal.enable = cfg.home.enable;
  };

  options = {
    sys.pkgs = {
      enable = lib.mkEnableOption "Enable System Packages";
      home = {
        enable = lib.mkEnableOption "Enable System Home Packages";
        wm = lib.mkOption {
          description = "Window Manager to use";
          type = lib.types.enum [
            "hyprland"
            "niri"
          ];
        };
      };
      server.enable = lib.mkEnableOption "Enable System Server Packages";
    };
  };
}
