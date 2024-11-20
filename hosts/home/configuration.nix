{
  config,
  inputs,
  pkgs,
  ...
}:

let
  vars = import ../../modules/nix/vars.nix;
in

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix/default.nix
  ];

  boot = {
    loader.grub.configurationLimit = 32;
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "${vars.user.home}/.steam/root/compatibilitytools.d";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        serif = [
          "DejaVu Serif"
          "Liberation Serif"
        ];
        sansSerif = [
          "DejaVu Sans"
          "FiraCode Nerd Font"
        ];
        monospace = [
          "FiraCode Nerd Font"
          "JetBrainsMono Nerd Font"
        ];
      };
    };
    packages = [ pkgs.nerdfonts ];
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      nvidiaSettings = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta; # NVidia Version (New -> Old): beta >= stable >= production
      powerManagement.enable = false;
    };
  };

  home-manager = {
    users = {
      ${vars.user.name} = import ./home.nix;
    };
  };

  networking = {
    defaultGateway = "192.168.0.1";
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
    interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.0.123";
        prefixLength = 24;
      }
    ];
    nameservers = [ "1.1.1.1" ];
  };

  nix = {
    settings = {
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  programs = {
    gamemode.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
      xwayland.enable = true;
    };
    hyprlock = {
      enable = true;
      package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    weylus.enable = true;
  };

  qt = {
    enable = false;
    platformTheme = "kde";
    style = "breeze";
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
          user = "${vars.user.name}";
        };
      };
    };
    hardware.openrgb.enable = true;
    hypridle.package = inputs.hypridle.packages.${pkgs.system}.hypridle;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
    };
    printing.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ]; # nvidia / nouveau
      xkb = {
        layout = "us";
        options = "caps:backspace";
        variant = "";
      };
    };
  };

  xdg = {
    portal.enable = true;
  };
}
