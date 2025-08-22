{ config, lib, ... }:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.thelounge.enable;
  vars = import ../../vars.nix;
in
{
  config = lib.mkIf enable {
    services = {
      ergochat = {
        enable = cfg.thelounge.ergo.enable;
        settings = {
          datastore = {
            autoupgrade = true;
            path = "/var/lib/ergo/ircd.db";
          };
          network.name = "MiX";
          oper-classes = {
            chat-moderator = {
              capabilities = [
                "ban"
                "kill"
                "nofakelag"
                "relaymsg"
                "roleplay"
                "sajoin"
                "samode"
                "snomasks"
                "vhosts"
              ];
              title = "Chat Moderator";
            };
            server-admin = {
              capabilities = [
                "accreg"
                "chanreg"
                "defcon"
                "history"
                "massmessage"
                "metadata"
                "rehash"
              ];
              extends = "chat-moderator";
              title = "Server Admin";
            };
          };
          opers.admin = {
            class = "server-admin";
            password = "$2a$04$k74NXvQCcTIQXm1RvJ29suNStbD4.62fhqXvwBIsg.hou/lwjd4.u";
          };
          server = {
            name = vars.my.domain;
            listeners.":${toString cfg.thelounge.ergo.port}" = { };
          };
        };
      };
      nginx.virtualHosts.${cfg.thelounge.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.thelounge.port}";
      };
      thelounge = {
        enable = true;
        extraConfig = {
          defaults = {
            host = vars.my.domain;
            join = "#general";
            name = "MiX";
            nick = "Gast%%%%";
            port = cfg.thelounge.ergo.port;
            leaveMessage = "Tschau";
            username = "gast";
          };
          reverseProxy = true;
        };
        port = cfg.thelounge.port;
        public = true;
      };
    };
  };
}
