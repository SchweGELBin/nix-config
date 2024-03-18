{ config, inputs, pkgs, ... }:
{

imports = [
  ./hardware-configuration.nix
  inputs.home-manager.nixosModules.default
  inputs.sops-nix.nixosModules.default
];

boot = {
  loader = {
    efi.canTouchEfiVariables = false; 
    grub = {
      enable = true;
      configurationLimit = 32; 
      device = "nodev";
      efiInstallAsRemovable = true;
      efiSupport = true; 
      useOSProber = true;
    }; 
  };   
  #extraModprobeConfig = ''options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1'';
  #extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ]; 
  kernelPackages = pkgs.linuxPackages_testing; # Kernel Version: testing = mainline, latest = stable
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
    QT_QPA_PLATFORMTHEME = "kvantum";
  };
  systemPackages = with pkgs; [
    age android-tools
    bat blender btop
    (catppuccin.override{accent="mauve";variant="macchiato";})
    (catppuccin-gtk.override{accents=["mauve"];size="standard";variant="macchiato";})
    cmake
    fusee-nano
    gamemode gamescope gcc gimp git gparted
    heroic hyprshot
    inetutils inkscape
    jdk
    kitty krita
    libnotify libreoffice-fresh librewolf
    libsForQt5.qt5ct libsForQt5.qtstyleplugin-kvantum
    mako mangohud mari0 mpv
    neofetch nodejs
    obs-studio openrgb
    papermc papirus-icon-theme pavucontrol pmbootstrap prismlauncher
    rofi rofimoji
    sops steam superTuxKart swww
    unzip
    ventoy
    waybar webcord-vencord wev weylus wget
    youtube-dl
  ];
};

fonts = {
  packages = with pkgs; [ nerdfonts ];
};

hardware = { 
  nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
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
    enable = false;
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
  config.allowUnfree = true;
};

programs = {
  hyprland = {
    enable = true; 
    package = inputs.hyprland.packages."${pkgs.system}".hyprland;
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
  getty.autologinUser = "michi";
  hardware.openrgb.enable = true;
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
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    videoDrivers = [ "nvidia" ]; 
    xkb = {
      layout = "us";
      options = "caps:backspace";
      variant = "";
    }; 
  };
};

sops = {
  age.keyFile = "/home/michi/.config/sops/age/keys.txt";
  defaultSopsFile = ./secrets/secrets.yaml;
  defaultSopsFormat = "yaml";
  secrets.password = { };
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
    initialPassword = "${config.sops.secrets.password.path}";
    isNormalUser = true; 
    packages = with pkgs; [];
    shell = pkgs.bash;
  };
};

xdg = {
  portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
};
}
