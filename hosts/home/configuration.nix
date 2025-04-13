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
    ../../modules/nix
  ];

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
    packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.liberation
    ];
  };

  hardware = {
    graphics.enable = true;
    nvidia = {
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta; # NVidia Version (New -> Old): beta >= stable >= production
    };
  };

  home-manager = {
    users = {
      ${vars.user.name} = import ./home.nix;
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
    ssh = {
      enableAskPassword = false;
      startAgent = true;
    };
    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    ydotool.enable = true;
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
      exportConfiguration = true;
      videoDrivers = [ "nvidia" ]; # nvidia / nouveau
    };
  };

  xdg = {
    portal.enable = true;
  };

  # Custom modules
  sys = {
    boot.configs = 32;
  };
  sys-pkgs.home.enable = true;
}
