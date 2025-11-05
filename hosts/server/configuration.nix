let
  vars = import ../../modules/vars.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix
  ];

  home-manager = {
    users = {
      ${vars.user.name} = import ./home.nix;
    };
  };

  # Custom modules
  sys = {
    fonts.enable = false;
    gickup = {
      enable = true;
      cron.enable = true;
    };
    greeter.enable = false;
    hardware.enable = false;
    minecraft.enable = true;
    nginx = {
      enable = true;
      collabora.enable = false;
      immich.enable = false;
      nextcloud.enable = false;
      ollama.enable = false;
      onlyoffice.enable = false;
    };
    networking = {
      hostName = vars.user.hostname.server;
      nat.enable = true;
      static = {
        enable = true;
        mode = "hetzner";
        v4 = {
          enable = true;
          ip = "138.199.210.86";
        };
        v6 = {
          enable = true;
          ip = "2a01:4f8:1c1a:d504::1";
        };
      };
    };
    nix.gc.enable = true;
    pkgs.server.enable = true;
    ryuldn.enable = false;
    security = {
      acme.enable = true;
      ssh.enable = true;
    };
    smoos.enable = true;
    sound.enable = false;
    wireguard = {
      autostart.enable = true;
      mode = "server";
    };
  };
}
