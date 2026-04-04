{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  enable = cfg.enable && cfg.website.enable;
in
{
  imports = [ inputs.nur.nixosModules.default ];

  config = lib.mkIf enable {
    services.nginx.virtualHosts.${cfg.domain} = {
      enableACME = true;
      default = true;
      forceSSL = true;
      root =
        if (cfg.website.mode == "local") then
          "/var/www"
        else if (cfg.website.mode == "public") then
          pkgs.nur.website
        else
          null;
    };
  };
}
