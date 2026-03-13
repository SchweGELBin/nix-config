{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.bluemap.enable;
  mcworld = config.services.minecraft-server.dataDir + "/world";
in
{
  config = lib.mkIf enable {
    services = {
      bluemap = {
        enable = true;
        coreSettings.metrics = false;
        enableNginx = true;
        eula = true;
        host = cfg.bluemap.fqdn;
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
      nginx.virtualHosts.${cfg.bluemap.fqdn} = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };
}
