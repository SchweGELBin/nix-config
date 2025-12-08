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
  vars = import ../vars.nix;
in
{
  imports = [
    inputs.nur.nixosModules.default
    inputs.sops-nix.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {
    nur.smoos = {
      enable = true;
      cs = {
        enable = cfg.cs.enable;
        package = pkgs.nur.smoos-cs;
        bot = {
          enable = cfg.cs.bot.enable;
          package = pkgs.nur.smoos-bot;
          settings.discord_id = toString vars.my.discordid;
        };
        secretFile = secrets.smoos-cs_env.path;
        settings = {
          force = true;
          jsonapi = true;
          port = cfg.cs.port;
        };
      };
      rs = {
        enable = cfg.rs.enable;
        package = pkgs.nur.smoos-rs;
        bot = {
          enable = cfg.rs.bot.enable;
          package = pkgs.nur.smoos-bot;
          settings.discord_id = toString vars.my.discordid;
        };
        secretFile = secrets.smoos-rs_env.path;
        settings = {
          force = true;
          jsonapi = true;
          port = cfg.rs.port;
        };
      };
    };

    sops.secrets = {
      smoos-cs_env.owner = "smoos";
      smoos-rs_env.owner = "smoos";
    };
  };

  options = {
    sys.smoos = {
      enable = lib.mkEnableOption "Enable Super Mario Odyssey: Online Server";
      cs = {
        enable = lib.mkEnableOption "Enable SMOOS-CS";
        bot.enable = lib.mkEnableOption "Enable SMOOS-Bot";
        port = lib.mkOption {
          description = "SMOOS-CS port";
          type = lib.types.int;
        };
      };
      rs = {
        enable = lib.mkEnableOption "Enable SMOOS-RS";
        bot.enable = lib.mkEnableOption "Enable SMOOS-Bot";
        port = lib.mkOption {
          description = "SMOOS-RS port";
          type = lib.types.int;
        };
      };
    };
  };
}
