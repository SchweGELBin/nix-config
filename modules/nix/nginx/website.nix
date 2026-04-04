{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  nginx = config.sys.nginx;
  cfg = nginx.website;
in
{
  imports = [ inputs.nur.nixosModules.default ];

  config = lib.mkIf (nginx.enable && cfg.enable) {
    services.nginx.virtualHosts.${nginx.domain} = {
      enableACME = true;
      default = true;
      forceSSL = true;
      root =
        if (cfg.mode == "local") then
          "/var/www"
        else if (cfg.mode == "public") then
          pkgs.nur.website
        else
          null;
    };
  };

  options = {
    sys.nginx.website = {
      enable = lib.mkEnableOption "Enable Website";
      mode = lib.mkOption {
        default = "local";
        description = "Website Mode/Origin";
        type = lib.types.enum [
          "local"
          "public"
        ];
      };
    };
  };
}
