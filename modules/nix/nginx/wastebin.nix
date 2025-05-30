{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.wastebin.enable;

  secrets = config.sops.secrets;
  vars = import ../vars.nix;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf enable {
    services = {
      wastebin = {
        enable = true;
        secretFile = secrets.wastebin_env.path;
        settings = {
          WASTEBIN_ADDRESS_PORT = "127.0.0.1:${toString cfg.wastebin.port}";
          WASTEBIN_BASE_URL = "https://wastebin.${vars.my.domain}";
        };
      };
      nginx.virtualHosts."wastebin.${vars.my.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/".proxyPass = "http://localhost:${toString cfg.wastebin.port}";
      };
    };
    sops.secrets.wastebin_env.owner = "root";
  };
}
