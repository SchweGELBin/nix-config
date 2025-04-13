{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.sys.services.minecraft.enable {
    networking.firewall.allowedTCPPorts = [ config.sys.services.minecraft.port ];

    services.minecraft-server = {
      enable = true;
      declarative = true;
      eula = true;
      jvmOpts = "-Xms2G -Xmx2G";
      serverProperties = {
        "query.port" = config.sys.services.minecraft.port;
        difficulty = "hard";
        enable-command-block = false;
        enforce-whitelist = true;
        force-gamemode = true;
        max-players = 7;
        motd = "MiX MC";
        op-permission-level = 2;
        server-port = config.sys.services.minecraft.port;
        simulation-distance = 6;
        view-distance = 8;
        white-list = false;
      };
      whitelist = {
        schwegelbin = "bc3a1c45-03cb-43c6-b860-1def6fddcdb9";
      };
    };
  };

  options = {
    sys.services.minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft Server";
      port = lib.mkOption {
        description = "Minecraft Port";
        type = lib.types.int;
      };
    };
  };
}
