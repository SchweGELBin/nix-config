{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.bluemap;

  mcworld = config.services.minecraft-server.dataDir + "/world";
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      bluemap = {
        enable = true;
        coreSettings.metrics = false;
        enableNginx = true;
        eula = true;
        host = cfg.fqdn;
        maps = {
          end = {
            sorting = 2;
            world = mcworld + "_the_end";
          };
          nether = {
            sorting = 1;
            world = mcworld + "_nether";
          };
          overworld.world = mcworld;
        };
        onCalendar = "*-*-* 05:30:00";
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };

  options = {
    sys.nginx.bluemap = {
      enable = lib.mkEnableOption "Enable BlueMap";
      fqdn = lib.mkOption {
        default = "mc.${nginx.domain}";
        description = "BlueMap Domain";
        type = lib.types.str;
      };
    };
  };
}
