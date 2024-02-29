{ config, inputs, pkgs, ... }:
{

imports = [
  ./hardware-configuration.nix
  inputs.home-manager.nixosModules.default
];

system.stateVersion = "23.11";

nixpkgs.config.allowUnfree = true;

boot = {
  loader = {
    grub = {
      enable = true;
      useOSProber = true;
      device = "nodev";
      configurationLimit = 32;
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
    efi.canTouchEfiVariables = false;
  };
  kernelPackages = pkgs.linuxPackages;
  extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';
};

networking = {
  hostName = "nix";
  networkmanager.enable = true;
};

nix = {
  settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
};

time.timeZone = "Europe/Berlin";

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

console = {
  font = "Lat2-Terminus16";
  useXkbConfig = true;
};

services.xserver = {
  enable = true;
  xkb = {
    layout = "us";
    options = "caps:backspace";
    variant = "";
  };
  videoDrivers = [ "nvidia" ];
  displayManager.gdm = {
    enable = true;
    wayland = true;
  };
};

environment.sessionVariables = {
  WLR_NO_HARDWARE_CURSORS = "1";
  NIXOS_OZONE_WL = "1";
  NIXOS_INSTALL_BOOTLOADER = "1";
};

hardware = {
  opengl.enable = true;
  nvidia.modesetting.enable = true;
};

services.printing.enable = true;

users.users.michi = {
  isNormalUser = true;
  initialPassword = "1234";
  description = "michi";
  extraGroups = [
    "networkmanager"
    "wheel"
  ];
  packages = with pkgs; [];
  shell = pkgs.bash;
};

services.getty.autologinUser = "michi";

programs.hyprland = {
  enable = true;
  xwayland.enable = true;
  package = inputs.hyprland.packages."${pkgs.system}".hyprland;
};

xdg.portal = {
  enable = true;
  extraPortals = [
    pkgs.xdg-desktop-portal-gtk
  ];
};

 sound.enable = true;

security = {
  rtkit.enable = true;
  polkit.enable = true;
};

services.pipewire = {
  enable = true;
  alsa = {
    enable = true;
    support32Bit = true;
  };
  pulse.enable = true;
  jack.enable = true;
};

programs.zsh.enable = true;

fonts.packages = with pkgs; [
  nerdfonts
];

programs.neovim = {
  enable = true;
  defaultEditor = true;
};

home-manager = {
  extraSpecialArgs = { inherit inputs; };
  users = {
    "michi" = import ./home.nix;
  };
};

environment.systemPackages = with pkgs; [
  kitty
  wget
];

# Enable the OpenSSH daemon.
# services.openssh.enable = true;

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;

# system.copySystemConfiguration = true;

# For more information, see `man configuration.nix`

}

