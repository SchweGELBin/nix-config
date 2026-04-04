{
  config,
  lib,
  pkgs,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.piped;
in
{
  config = lib.mkIf (nginx.enable && cfg.enable) {
    services.nginx.virtualHosts.${cfg.fqdn} = {
      enableACME = true;
      forceSSL = true;
      root = pkgs.piped;
    };
  };

  options = {
    sys.nginx.piped = {
      enable = lib.mkEnableOption "Enable Piped";
      fqdn = lib.mkOption {
        default = "pd.${nginx.domain}";
        description = "Piped Domain";
        type = lib.types.str;
      };
    };
  };
}
