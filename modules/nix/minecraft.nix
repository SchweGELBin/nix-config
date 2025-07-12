{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.minecraft;
in
{
  config = lib.mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      package = pkgs.papermcServers.papermc-1_21_4;
      declarative = true;
      eula = true;
      jvmOpts = "-Xms128M -Xmx2G";
      openFirewall = true;
      serverProperties = {
        "query.port" = cfg.port;
        difficulty = "hard";
        enable-command-block = false;
        enforce-whitelist = true;
        force-gamemode = true;
        max-players = 7;
        motd = "MiX MC";
        op-permission-level = 2;
        server-port = cfg.port;
        simulation-distance = 6;
        view-distance = 8;
        white-list = false;
      };
      whitelist = {
        mixbot = "81a1f96b-6231-48d7-8f06-bfb21bad12cc";
        schwegelbin = "bc3a1c45-03cb-43c6-b860-1def6fddcdb9";
      };
    };
  };

  options = {
    sys.minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft Server";
      port = lib.mkOption {
        description = "Minecraft Port";
        type = lib.types.int;
      };
    };
  };
}
