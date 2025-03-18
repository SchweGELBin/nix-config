{
  inputs,
  pkgs,
  ...
}:

let
  vars = import ../../modules/nix/vars.nix;
in

{
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
    inputs.home-manager.nixosModules.default
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = false;
      grub = {
        enable = true;
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        useOSProber = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest; # Kernel Version: testing = mainline, latest = stable
    tmp.cleanOnBoot = true;
  };

  catppuccin = {
    enable = true;
    accent = vars.cat.accent;
    cache.enable = true;
    flavor = vars.cat.flavor;
  };

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  environment = {
    sessionVariables = {
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      LIBVA_DRIVER_NAME = "nvidia";
      NIXOS_INSTALL_BOOTLOADER = 1;
      NIXOS_OZONE_WL = 1;
    };
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    useGlobalPkgs = true;
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
    firewall.enable = true;
    interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.0.123";
        prefixLength = 24;
      }
    ];
    nameservers = [
      "1.1.1.3"
      "1.0.0.3"
    ];
    networkmanager.enable = true;
    stevenblack = {
      enable = true;
      block = [
        "fakenews"
        "gambling"
        "porn"
      ];
    };
  };

  nix = {
    optimise.automatic = true;
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
      nvidia.acceptLicense = true;
    };
    overlays = [ inputs.fenix.overlays.default ];
  };

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk;
    };
    zsh.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    openssh.enable = true;
  };

  system = {
    stateVersion = "${vars.user.stateVersion}";
  };

  time = {
    timeZone = "Europe/Berlin";
  };

  users = {
    users.${vars.user.name} = {
      description = "${vars.user.name}";
      extraGroups = [
        "docker"
        "networkmanager"
        "wheel"
        "ydotool"
      ];
      initialPassword = "1234";
      isNormalUser = true;
      shell = pkgs.zsh;
    };
  };
}
