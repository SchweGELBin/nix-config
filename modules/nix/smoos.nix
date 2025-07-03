{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.smoos;
  secrets = config.sops.secrets;
in
{
  imports = [
    inputs.nur.nixosModules.default
    inputs.sops-nix.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    nur.smoos = {
      enable = true;
      bot = {
        enable = cfg.bot.enable;
        package = inputs.nur.packages.${pkgs.system}.smoos-bot;
        secretFile = secrets.smoos_env.path;
        settings.SMOOS_API_PORT = cfg.bot.port;
      };
      cs = {
        enable = cfg.cs.enable;
        package = inputs.nur.packages.${pkgs.system}.smoos-cs;
        secretFile = secrets.smoos_env.path;
        settings = {
          force = true;
          jsonapi = true;
          port = cfg.cs.port;
        };
      };
    };

    sops.secrets.smoos_env.owner = "smoos";
  };

  options = {
    sys.smoos = {
      enable = lib.mkEnableOption "Enable Super Mario Odyssey: Online Server";
      bot = {
        enable = lib.mkEnableOption "Enable SMOOS-Bot";
        port = lib.mkOption {
          description = "SMOOS-Bot port, should match a server's port";
          type = lib.types.int;
        };
      };
      cs = {
        enable = lib.mkEnableOption "Enable SMOOS-CS";
        port = lib.mkOption {
          description = "SMOOS-CS port";
          type = lib.types.int;
        };
      };
    };
  };
}
