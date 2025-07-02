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
        environmentFile = secrets.smoos_env.path;
        package = inputs.nur.packages.${pkgs.system}.smoos-bot;
      };
      cs = {
        enable = cfg.cs.enable;
        environmentFile = secrets.smoos_env.path;
        package = inputs.nur.packages.${pkgs.system}.smoos-cs;
      };
    };

    sops.secrets.smoos_env.owner = "smoos";
  };

  options = {
    sys.smoos = {
      enable = lib.mkEnableOption "Enable Super Mario Odyssey: Online Server";
      bot.enable = lib.mkEnableOption "Enable Super Mario Odyssey: Online Server - Bot";
      cs.enable = lib.mkEnableOption "Enable Super Mario Odyssey: Online Server - C#";
    };
  };
}
