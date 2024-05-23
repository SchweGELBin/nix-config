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
  kernelPackages = pkgs.linuxPackages_6_8; # Kernel Version: testing = mainline, latest = stable
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
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/michi/.steam/root/compatibilitytools.d";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
  systemPackages = with pkgs; [
    androidSdk audacity
    bat bibata-cursors blender btop
    cargo cava cinnamon.nemo cmake cmatrix
    fastfetch ffmpeg fusee-nano fuzzel
    gcc gedit gimp git glfw godot_4 grim
    imagemagick imv 
    inputs.hypridle.packages.${pkgs.system}.hypridle
    inputs.hyprpaper.packages.${pkgs.system}.hyprpaper
    inputs.hyprpicker.packages.${pkgs.system}.hyprpicker
    inputs.waybar.packages.${pkgs.system}.waybar
    jq
    kdePackages.kdenlive
    kitty krita
    legendary-gl libnotify libreoffice-qt-fresh librewolf
    mako mangohud mpv
    neo-cowsay nodejs
    nodePackages_latest.conventional-changelog-cli
    obs-studio
    papermc papirus-icon-theme pavucontrol pulseaudio
    rustc
    slurp steam
    toilet
    unzip
    vesktop
    weylus wineWowPackages.stagingFull wget wl-clipboard wlogout
    yt-dlp
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
  zsh.enable = true;
};

qt = {
  enable = true;
  platformTheme = "kde";
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
    url = "https://raw.githubusercontent.com/Gingeh/wallpapers/main/waves/cat-waves.png";
    hash = "sha256-aiG7debgjOCWRBp2xUOMOVGvIDWtd4NirsktxL19De4=";
  };
  opacity = {
    popups = 0.7;
    terminal = 0.7; 
  };
  polarity = "dark";
};

system = {
  stateVersion = "23.11";
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
    packages = with pkgs; [];
    shell = pkgs.bash;
  };
};

xdg = { 
  portal.enable = true;
};
}
