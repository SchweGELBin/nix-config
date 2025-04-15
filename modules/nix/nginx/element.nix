{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.element.enable;

  vars = import ../vars.nix;
in
{
  config = lib.mkIf enable {
    services = {
      nginx.virtualHosts."element.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        root = pkgs.element-web.override {
          conf = {
            default_server_config."m.homeserver" = {
              base_url = "https://matrix.${vars.my.domain}";
              server_name = vars.my.domain;
            };
            default_theme = "dark";
            disable_custom_urls = true;
          };
        };
      };
    };
  };
}
