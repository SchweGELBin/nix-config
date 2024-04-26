{ config, inputs, pkgs, ... }:
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
  extraModprobeConfig = ''options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1'';
  extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  kernelPackages = pkgs.linuxPackages_latest; # Kernel Version: testing = mainline, latest = stable
};

console = {
  font = "Lat2-Terminus16";
  useXkbConfig = true;
};

environment = {
  sessionVariables = {
    NIXOS_INSTALL_BOOTLOADER = "1";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    QT_QPA_PLATFORMTHEME = "qt6ct";
  };
  systemPackages = with pkgs; [
    android-tools audacity
    bat blender btop
    cmake
    dolphin
    ffmpeg fusee-nano
    gamemode gcc gimp git grim
    heroic hyprpaper
    imv inetutils
    jdk jq
    kitty krita
    libnotify librewolf
    libsForQt5.qt5ct libsForQt5.qtstyleplugin-kvantum
    mako mangohud mpv
    neofetch nodejs
    obs-studio
    p7zip papirus-icon-theme pavucontrol prismlauncher-qt5
    qt6.full
    slurp steam
    unrar unzip
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
    open = false;
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
    nvidia.acceptLicense = true;
  };
};

programs = {
  hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
  };
  neovim = {
    enable = true;
    defaultEditor = true;
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
