{ config, lib, ... }:
let
  nginx = config.sys.nginx;
  cfg = nginx.thelounge;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      ergochat = {
        enable = cfg.ergo.enable;
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
            name = nginx.domain;
            listeners.":${toString cfg.ergo.port}" = { };
          };
        };
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
      thelounge = {
        enable = true;
        extraConfig = {
          defaults = {
            host = "localhost";
            join = "#general";
            name = "MiX IRC";
            nick = "gast%%%";
            port = cfg.ergo.port;
            tls = false;
            username = "gast";
          };
          reverseProxy = true;
        };
        port = cfg.port;
        public = true;
      };
    };
  };

  options = {
    sys.nginx.thelounge = {
      enable = lib.mkEnableOption "Enable The Lounge";
      ergo = {
        enable = lib.mkEnableOption "Enable Ergo" // {
          default = true;
        };
        port = lib.mkOption {
          default = 6667;
          description = "Ergo Port";
          type = lib.types.port;
        };
      };
      fqdn = lib.mkOption {
        default = "irc.${nginx.domain}";
        description = "The Lounge Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 6789;
        description = "The Lounge Port";
        type = lib.types.port;
      };
    };
  };
}
