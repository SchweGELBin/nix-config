{
  config,
  inputs,
  pkgs,
  ...
}:

let
  vars = import ./modules/nix/vars.nix;
in

{

  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = false;
      grub = {
        enable = true;
        configurationLimit = 64;
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        useOSProber = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest; # Kernel Version: testing = mainline, latest = stable
    kernelParams = [ "nvidia-drm.fbdev=1" ];
  };

  catppuccin = {
    enable = true;
    accent = vars.cat.accent;
    flavor = vars.cat.flavor;
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment = {
    sessionVariables = {
      NIXOS_INSTALL_BOOTLOADER = "1";
      NIXOS_OZONE_WL = "1";
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "${vars.user.home}/.steam/root/compatibilitytools.d";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
    systemPackages = with pkgs; [
      cachix
      cmake
      gcc
      wget
    ];
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
          "FiraCode Nerd Font Mono"
          "JetBrainsMono Nerd Font Mono"
        ];
      };
    };
    packages = [ pkgs.nerdfonts ];
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta; # NVidia Version (New -> Old): beta >= stable >= production
      powerManagement.enable = false;
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    useGlobalPkgs = true;
    users = {
      ${vars.user.name} = import ./home.nix;
    };
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEADUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
    hostName = "nix";
    networkmanager.enable = true;
  };

  nix = {
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
  };

  programs = {
    gamemode.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    hyprlock = {
      enable = true;
      package = inputs.hyprlock.packages.${pkgs.system}.hyprlock;
    };
    java = {
      enable = true;
      package = pkgs.jdk;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    weylus.enable = true;
    zsh = {
      enable = true;
      ohMyZsh = {
        enable = true;
        theme = "simple";
      };
    };
  };

  qt = {
    enable = false;
    platformTheme = "kde";
    style = "breeze";
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.greetd}/bin/agreety --cmd Hyprland";
        };
      };
    };
    hardware.openrgb.enable = true;
    hypridle.package = inputs.hypridle.packages.${pkgs.system}.hypridle;
    openssh.enable = true;
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

  system = {
    stateVersion = "24.05";
  };

  time = {
    timeZone = "Europe/Berlin";
  };

  users = {
    users.${vars.user.name} = {
      description = "${vars.user.name}";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      initialPassword = "1234";
      isNormalUser = true;
      packages = with pkgs; [ ];
      shell = pkgs.zsh;
    };
  };

  xdg = {
    portal.enable = true;
  };
}
