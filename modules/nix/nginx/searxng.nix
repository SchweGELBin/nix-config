{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.searxng;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
      searx = {
        enable = true;
        domain = cfg.fqdn;
        environmentFile = secrets.searx_env.path;
        redisCreateLocally = true;
        settings = {
          general.instance_name = "MiX SearXNG";
          server = {
            base_url = "https://${cfg.fqdn}";
            port = cfg.port;
          };
          ui.theme_args.simple_style = "black";
        };
      };
    };
    sops.secrets.searx_env.owner = "searx";
  };

  options = {
    sys.nginx.searxng = {
      enable = lib.mkEnableOption "Enable SearXNG";
      fqdn = lib.mkOption {
        default = "searx.${nginx.domain}";
        description = "SearXNG Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 8888;
        description = "SearXNG Port";
        type = lib.types.port;
      };
    };
  };
}
