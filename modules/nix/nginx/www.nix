{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
in
{
  imports = [ inputs.nur.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts.${cfg.domain} = {
      enableACME = true;
      default = true;
      forceSSL = true;
      root = if cfg.website.enable then inputs.nur.packages.${pkgs.system}.website else "/var/www";
    };
  };
}
