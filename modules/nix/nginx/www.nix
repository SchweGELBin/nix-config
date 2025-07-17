{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.nginx;
  vars = import ../../vars.nix;
in
{
  imports = [ inputs.nur.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    services.nginx.virtualHosts.${vars.my.domain} = {
      enableACME = true;
      default = true;
      forceSSL = true;
      root = if cfg.website.enable then inputs.nur.packages.${pkgs.system}.mixbot else "/var/www";
    };
  };
}
