{
  config,
  pkgs,
  ...
}:

let
  vars = import ../../modules/nix/vars.nix;
in

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ../../modules/nix/default.nix
  ];

  boot = {
    loader.grub.configurationLimit = 2;
  };

  environment = {
    systemPackages = with pkgs; [
      arion
      cachix
      cmake
      gcc
      wget
    ];
  };

  home-manager = {
    users = {
      ${vars.user.name} = import ./home.nix;
    };
  };

  networking = {
    firewall.enable = false;
  };

  services = {
    minecraft-server = {
      enable = true;
      declarative = true;
      eula = true;
      jvmOpts = "-Xms2G -Xmx2G";
      openFirewall = false;
      package = pkgs.papermc;
      serverProperties = {
        difficulty = "hard";
        enable-command-block = false;
        enforce-whitelist = true;
        force-gamemode = true;
        max-players = 7;
        motd = "MiX Paper";
        op-permission-level = 2;
        simulation-distance = 6;
        view-distance = 8;
        white-list = true;
      };
      whitelist = {
        schwegelbin = "bc3a1c45-03cb-43c6-b860-1def6fddcdb9";
      };
    };
    nginx.enable = true;
  };

  users = {
    users.${vars.user.name} = {
      openssh.authorizedKeys.keys = [ vars.user.ssh ];
    };
  };

  virtualisation = {
    docker.enable = true;
    podman = {
      enable = true;
      defaultNetwork.dnsname.enable = true;
      dockerSocket.enable = true;
    };
  };

  zramSwap = {
    enable = true;
  };
}
