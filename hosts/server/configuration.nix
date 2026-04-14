let
  vars = import ../../modules/vars.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nix
  ];

  home-manager.users.${vars.user.name} = import ./home.nix;

  # Custom modules
  sys = {
    fonts.enable = false;
    greeter.enable = false;
    hardware.enable = false;
    minecraft.enable = true;
    nginx = {
      enable = true;
      bluemap.enable = true;
      coturn.enable = true;
      element.enable = true;
      forgejo.enable = true;
      jellyfin.enable = true;
      mail.enable = true;
      matrix.enable = true;
      radicale.enable = true;
      searxng.enable = true;
      wastebin.enable = true;
      website = {
        enable = true;
        mode = "public";
      };
    };
    networking = {
      adblock.enable = false;
      hostName = "server";
      nat.enable = true;
      static = {
        enable = true;
        dhcp.enable = true;
        mode = "oracle";
        v4 = {
          enable = true;
          ip = "10.0.0.2";
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
