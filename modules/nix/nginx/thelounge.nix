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
          accounts.nick-reservation.guest-nickname-format = "gast*";
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
          opers = {
            admin = {
              class = "server-admin";
              password = "$2a$04$czT6h2woQY6AP3bJx7yPrO23Cg8MNS7yag9PhSL3vTK6x6BZmGHS2";
            };
            moderator = {
              class = "chat-moderator";
              password = "$2a$04$Atz4qI5KUhny3bBcA71iKuxvpT/0v/BmAVQXHdD3UIfPwWpRmEegy";
            };
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
            nick = "gast%%%%";
            port = cfg.ergo.port;
            tls = false;
            username = "gast";
          };
          lockNetwork = true;
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
          default = 6769;
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
        default = 6770;
        description = "The Lounge Port";
        type = lib.types.port;
      };
    };
  };
}
