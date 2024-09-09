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
    ./networking.nix
    ../../modules/nix/default.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  home-manager = {
    users = {
      ${vars.user.name} = import ./home.nix;
    };
  };

  networking = {
    firewall.enable = false;
  };

  nixpkgs = {
    overlays = [ inputs.nix-minecraft.overlay ];
  };

  services = {
    minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = false;
      servers = {
        paper = {
          package = pkgs.paperServers.paper;
          autoStart = false;
          jvmOpts = "-Xms2G -Xmx2G";
          restart = "no";
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
      };
    };
    nginx.enable = true;
  };

  users = {
    users.root = {
      openssh.authorizedKeys.keys = [ vars.user.ssh ];
    };
  };

  zramSwap = {
    enable = true;
  };
}
