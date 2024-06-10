{
  config,
  inputs,
  pkgs,
  ...
}:

let
  android = {
    composition = pkgs.androidenv.composeAndroidPackages { platformVersions = [ "34" ]; };
    sdk = android.composition.androidsdk;
  };
  vars = import ./modules/nix/vars.nix;
in

{

  imports = [ ./hardware-configuration.nix ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = false;
      grub = {
        enable = true;
        catppuccin = {
          enable = true;
          flavor = vars.cat.flavor;
        };
        configurationLimit = 64;
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        useOSProber = true;
      };
    };
    plymouth = {
      catppuccin = {
        enable = true;
        flavor = vars.cat.flavor;
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
    catppuccin = {
      enable = true;
      flavor = vars.cat.flavor;
    };
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment = {
    sessionVariables = {
      ANDROID_SDK_ROOT = "${android.sdk}/libexec/android-sdk";
      NIXOS_INSTALL_BOOTLOADER = "1";
      NIXOS_OZONE_WL = "1";
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/michi/.steam/root/compatibilitytools.d";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
    systemPackages = with pkgs; [
      android.sdk
      bibata-cursors
      cmake
      ffmpeg
      gcc
      grim
      imagemagick
      legendary-gl
      libnotify
      mako
      nixfmt-rfc-style
      pavucontrol
      slurp
      unzip
      wineWowPackages.stagingFull
      wget
      wl-clipboard
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "Liberation Serif" ];
        sansSerif = [ "DejaVu Sans" ];
        monospace = [ "JetBrainsMono Nerd Font Mono" ];
      };
    };
    packages = [ pkgs.nerdfonts ];
  };

  hardware = {
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = false;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta; # NVidia Version (New -> Old): beta >= stable >= production
      powerManagement.enable = false;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    useGlobalPkgs = true;
    users = {
      "michi" = import ./home.nix;
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
    settings.experimental-features = [
      "flakes"
      "nix-command"
    ];
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
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
    openssh.enable = false;
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

  sound = {
    enable = true;
  };

  system = {
    stateVersion = "24.05";
  };

  time = {
    timeZone = "Europe/Berlin";
  };

  users = {
    users.michi = {
      description = "michi";
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
