{ config, inputs, pkgs, ... }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "34" ];
  };
  androidSdk = androidComposition.androidsdk;
  systemFonts = pkgs.nerdfonts;
in

{

  imports = [
    ./hardware-configuration.nix
  ];

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
    kernelParams = [
      "nvidia-drm.fbdev=1"
    ];
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment = {
    sessionVariables = {
      ANDROID_SDK_ROOT = "${androidSdk}/libexec/android-sdk";
      NIXOS_INSTALL_BOOTLOADER = "1";
      NIXOS_OZONE_WL = "1";
      PRETTIERD_DEFAULT_CONFIG = "/home/michi/.config/prettier/.prettierrc.json";
      PRETTIERD_LOCAL_PRETTIER_ONLY = "1";
      STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/michi/.steam/root/compatibilitytools.d";
      WLR_NO_HARDWARE_CURSORS = "1";
    };
    systemPackages = with pkgs; [
      androidSdk
      audacity
      bibata-cursors
      blender
      cargo
      cinnamon.nemo
      cmake
      cmatrix
      ffmpeg
      fusee-nano
      gcc
      gedit
      gimp
      glfw
      godot_4
      grim
      imagemagick
      inputs.hypridle.packages.${pkgs.system}.hypridle
      inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
      inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
      krita
      legendary-gl
      libnotify
      libreoffice-qt-fresh
      mako
      neo-cowsay
      nixpkgs-fmt
      nodejs
      nodePackages_latest.conventional-changelog-cli
      nodePackages_latest.prettier
      papermc
      papirus-icon-theme
      pavucontrol
      pipes-rs
      prettierd
      prismlauncher
      pulseaudio
      rustc
      slurp
      toilet
      unzip
      vesktop
      wineWowPackages.stagingFull
      wget
      wl-clipboard
    ];
  };

  fonts = {
    packages = [ systemFonts ];
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
    extraSpecialArgs = { inherit inputs; };
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
    settings.experimental-features = [ "flakes" "nix-command" ];
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
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    java = {
      enable = true;
      package = pkgs.jdk;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    waybar = {
      enable = false;
      package = inputs.waybar.packages.${pkgs.system}.waybar;
    };
    weylus.enable = true;
    zsh.enable = true;
  };

  qt = {
    enable = false;
    platformTheme = "kde";
    style = "breeze";
  };

  security = {
    pam.services = {
      hyprlock = { };
    };
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    getty.autologinUser = "michi";
    hardware.openrgb.enable = true;
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
      displayManager = {
        gdm = {
          enable = true;
          wayland = true;
        };
      };
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

  stylix = {
    autoEnable = true;
    cursor = {
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    fonts = {
      monospace = {
        name = "JetBrainsMono Nerd Font Mono";
        package = systemFonts;
      };
      sansSerif = {
        name = "DejaVu Sans";
        package = systemFonts;
      };
    };
    image = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/2y/wallhaven-2yx5og.jpg";
      hash = "sha256-BfxglbS7JoJyvtvwFETLWo9mcDjylLmcMpk0vW1AdKI=";
    };
    opacity = {
      popups = 0.7;
      terminal = 0.7;
    };
    polarity = "dark";
    targets = {
      gnome.enable = true;
      grub = {
        useImage = false;
      };
      nixvim = {
        transparent_bg = {
          main = false;
          sign_column = false;
        };
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
    users.michi = {
      description = "michi";
      extraGroups = [ "networkmanager" "wheel" ];
      initialPassword = "1234";
      isNormalUser = true;
      packages = with pkgs; [ ];
      shell = pkgs.bash;
    };
  };

  xdg = {
    portal.enable = true;
  };

}
