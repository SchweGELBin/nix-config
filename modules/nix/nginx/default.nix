{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  vars = import ../../vars.nix;
in
{
  imports = [
    ./bluemap.nix
    ./coturn.nix
    ./cryptpad.nix
    ./element.nix
    ./filebrowser.nix
    ./forgejo.nix
    ./immich.nix
    ./invidious.nix
    ./jellyfin.nix
    ./mail.nix
    ./matrix.nix
    ./nextcloud.nix
    ./ollama.nix
    ./opencloud.nix
    ./peertube.nix
    ./piped.nix
    ./radicale.nix
    ./searxng.nix
    ./thelounge.nix
    ./uptimekuma.nix
    ./vaultwarden.nix
    ./wastebin.nix
    ./weblate.nix
    ./website.nix
    ./websurfx.nix
    ./whoogle.nix
    ./zipline.nix
  ];

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.nginx = {
      enable = true;
      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
  };

  options = {
    sys.nginx = {
      enable = lib.mkEnableOption "Enable Nginx";
      domain = lib.mkOption {
        default = vars.my.domain;
        description = "Nginx Domain";
        type = lib.types.str;
      };
    };
  };
}
