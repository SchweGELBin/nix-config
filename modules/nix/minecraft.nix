{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.minecraft;
  secrets = config.sops.secrets;
  vars = import ../vars.nix;
in
{
  imports = [ inputs.nur.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts =
        lib.optional cfg.server.enable cfg.server.port
        ++ lib.optional cfg.server.rcon.enable cfg.server.rcon.port;
      allowedUDPPorts = lib.optional cfg.server.enable cfg.server.port;
    };

    nur.mixbot = {
      enable = cfg.bot.enable;
      package = pkgs.nur.mixbot;
      secretFile = secrets.mixbot_env.path;
      settings = {
        discord_id = toString vars.my.discordid;
        online = true;
      };
    };

    services.minecraft-server = {
      enable = cfg.server.enable;
      package = pkgs.papermcServers.papermc-1_21_10;
      declarative = true;
      eula = true;
      jvmOpts = cfg.server.ram;
      openFirewall = true;
      serverProperties = {
        difficulty = "hard";
        enable-command-block = false;
        enable-rcon = cfg.server.rcon.enable;
        enforce-whitelist = true;
        force-gamemode = true;
        max-players = 7;
        motd = "MiX MC";
        op-permission-level = 2;
        "query.port" = cfg.server.port;
        "rcon.password" = "V3ry S3cr3t P455w0rd";
        "rcon.port" = cfg.server.rcon.port;
        server-port = cfg.server.port;
        simulation-distance = 6;
        view-distance = 8;
        white-list = cfg.server.whitelist.enable;
      };
      whitelist = {
        ilikeyourcut = "c4ac655d-1da4-4e44-9bc1-2b556c44cb6f";
        lord_slavik = "7f6a1a19-9fda-447b-8339-cf4ef2568c64";
        mixbot = "81a1f96b-6231-48d7-8f06-bfb21bad12cc";
        muffin_xp = "c31c008f-9820-4b10-bae5-bbe3d65d2e04";
        nimelab = "91ca4c55-637b-4767-b0c3-75c0f8017e1d";
        schwegelbin = "bc3a1c45-03cb-43c6-b860-1def6fddcdb9";
      };
    };

    sops.secrets.mixbot_env.owner = lib.mkIf cfg.bot.enable "mixbot";
  };

  options = {
    sys.minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft";
      bot.enable = lib.mkEnableOption "Enable Minecraft Bot";
      server = {
        enable = lib.mkEnableOption "Enable Minecraft Server";
        port = lib.mkOption {
          description = "Minecraft Server Port";
          type = lib.types.port;
        };
        ram = lib.mkOption {
          description = "Minecraft RAM arguments";
          type = lib.types.str;
        };
        rcon = {
          enable = lib.mkEnableOption "Enable Minecraft Remote Control";
          port = lib.mkOption {
            description = "Minecraft Remote Control Port";
            type = lib.types.port;
          };
        };
        whitelist.enable = lib.mkEnableOption "Enable Minecraft Server Whitelist";
      };
    };
  };
}
