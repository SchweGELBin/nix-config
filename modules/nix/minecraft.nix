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
    networking.firewall = lib.mkIf cfg.server.enable {
      allowedTCPPorts = [ cfg.server.port ] ++ lib.optional cfg.server.rcon.enable cfg.server.rcon.port;
      allowedUDPPorts = [ cfg.server.port ];
    };

    nur.mixbot = lib.mkIf cfg.bot.enable {
      enable = true;
      package = pkgs.nur.mixbot;
      secretFile = secrets.mixbot_env.path;
      settings = {
        discord_id = toString vars.my.discordid;
        online = true;
      };
    };

    services.minecraft-server = lib.mkIf cfg.server.enable {
      enable = true;
      package = pkgs.papermcServers.papermc-1_21_11;
      declarative = true;
      eula = true;
      jvmOpts = lib.concatStringsSep " " ([ cfg.server.ram ] ++ cfg.server.extraJVM);
      serverProperties = {
        difficulty = "hard";
        enable-command-block = false;
        enable-rcon = cfg.server.rcon.enable;
        enforce-whitelist = true;
        force-gamemode = true;
        max-players =
          if cfg.server.whitelist.enable then
            lib.length (lib.attrValues config.services.minecraft-server.whitelist)
          else
            16;
        motd = "MiX MC";
        op-permission-level = 2;
        "query.port" = cfg.server.port;
        "rcon.password" = "V3ry S3cr3t P455w0rd";
        "rcon.port" = cfg.server.rcon.port;
        server-port = cfg.server.port;
        simulation-distance = 12;
        view-distance = 16;
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

    systemd.services.minecraft-server = lib.mkIf (cfg.server.enable && cfg.server.plugins.enable) {
      preStart =
        let
          bluemap = pkgs.fetchurl {
            url = "https://github.com/BlueMap-Minecraft/BlueMap/releases/download/v5.16/bluemap-5.16-paper.jar";
            hash = "sha256-eduusmBTLb1WYk+LzoqyL7yhWK5KKGCwT8zv+55Gdso=";
          };
          geyser = pkgs.fetchurl {
            url = "https://download.geysermc.org/v2/projects/geyser/versions/2.9.4/builds/1097/downloads/spigot";
            hash = "sha256-PSt+IRhn+SiJrxNSUJ/dQeKsqR4W/iP77zFeyOiMVSk=";
          };
        in
        ''
          if [ ! -d plugins ]; then mkdir plugins; fi
        ''
        + lib.optionalString cfg.server.plugins.bluemap.enable ''
          ln -sf ${bluemap} plugins/bluemap.jar
        ''
        + lib.optionalString cfg.server.plugins.geyser.enable ''
          ln -sf ${geyser} plugins/geyser.jar
        '';
    };
  };

  options = {
    sys.minecraft = {
      enable = lib.mkEnableOption "Enable Minecraft";
      bot.enable = lib.mkEnableOption "Enable Minecraft Bot";
      server = {
        enable = lib.mkEnableOption "Enable Minecraft Server";
        extraJVM = lib.mkOption {
          description = "Minecraft extra JVM arguments";
          type = with lib.types; listOf str;
        };
        plugins = {
          enable = lib.mkEnableOption "Enable Paper Plugins";
          bluemap.enable = lib.mkEnableOption "Enable Paper Plugin: BlueMap";
          geyser.enable = lib.mkEnableOption "Enable Paper Plugin: Geyser";
        };
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
