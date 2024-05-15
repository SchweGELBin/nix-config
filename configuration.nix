{ config, inputs, pkgs, ... }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [ "34" ];
  };
  androidSdk = androidComposition.androidsdk;
in

{

imports = [
  ./hardware-configuration.nix
  inputs.home-manager.nixosModules.default
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
    QT_QPA_PLATFORMTHEME = "qt6ct";
    STEAM_EXTRA_COMPAT_TOOLS_PATH = "/home/michi/.steam/root/compatibilitytools.d";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
  systemPackages = with pkgs; [
    androidSdk audacity
    bat blender btop
    cargo cmake
    dolphin
    fastfetch ffmpeg fusee-nano
    gcc gimp git godot_4 grim
    heroic hyprpaper
    imv
    jq
    kitty krita
    libnotify libreoffice-qt-fresh librewolf
    libsForQt5.qt5ct libsForQt5.qtstyleplugin-kvantum
    mako mangohud mpv
    nodejs
    obs-studio
    papermc papirus-icon-theme pavucontrol prismlauncher
    qt6.full
    rustc
    slurp steam
    unzip
    walker waybar webcord-vencord weylus wget wl-clipboard
    yt-dlp
  ];
};

fonts = {
  packages = with pkgs; [ nerdfonts ];
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

security = {
  polkit.enable = true;
  rtkit.enable = true;
};

services = {
  displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
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

xdg.portal.enable = true;
}
