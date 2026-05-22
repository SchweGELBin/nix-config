{
  config,
  inputs,
  lib,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.chhoto;
  secrets = config.sops.secrets;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services = {
      chhoto-url = {
        enable = true;
        environmentFiles = [ secrets.chhoto_env.path ];
        settings = {
          hash_algorithm = "Argon2";
          port = cfg.port;
          public_mode = true;
          site_url = "https://${cfg.fqdn}";
        };
      };
      nginx.virtualHosts.${cfg.fqdn} = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.port}";
      };
    };
    sops.secrets.chhoto_env.owner = "chhoto-url";
  };

  options = {
    sys.nginx.chhoto = {
      enable = lib.mkEnableOption "Enable Chhoto";
      fqdn = lib.mkOption {
        default = "url.${nginx.domain}";
        description = "Chhoto Domain";
        type = lib.types.str;
      };
      port = lib.mkOption {
        default = 4567;
        description = "Chhoto Port";
        type = lib.types.port;
      };
    };
  };
}
