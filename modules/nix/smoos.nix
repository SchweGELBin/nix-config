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
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    sops.secrets.smoos_env.owner = "smoo";

    systemd.services = {
      smoos = {
        enable = true;
        preStart = ''
          if [ ! -f ./settings.json ]; then
            cp ${inputs.nur.packages.${pkgs.system}.smoos-cs}/settings.json .
            sed -i '/JsonApi/{n;s/false/true/}' ./settings.json
            sed -i -e "s/\"SECRET_TOKEN_1\"/\"\$API_TOKEN_PUB\"/g" ./settings.json
            sed -i -e "s/\"SECRET_TOKEN_2\"/\"\$API_TOKEN\"/g" ./settings.json
          fi
        '';
        script = "${inputs.nur.packages.${pkgs.system}.smoos-cs}/bin/Server";
        serviceConfig = {
          EnvironmentFile = secrets.smoos_env.path;
          User = "smoo";
          WorkingDirectory = "/var/lib/smoo";
        };
        wantedBy = [ "multi-user.target" ];
      };
      smoos-bot = {
        enable = true;
        environment.SMOOS_API_PORT = toString cfg.port;
        script = lib.getExe inputs.nur.packages.${pkgs.system}.smoos-bot;
        serviceConfig = {
          EnvironmentFile = secrets.smoos_env.path;
          User = "smoo";
          WorkingDirectory = "/var/lib/smoo";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };

    users.users.smoo = {
      createHome = true;
      group = "systemd";
      home = "/var/lib/smoo";
      isSystemUser = true;
    };
  };

  options = {
    sys.smoos = {
      enable = lib.mkEnableOption "Enable Super Mario Odyssey: Online Server";
      port = lib.mkOption {
        description = "SMOOS Port";
        type = lib.types.int;
      };
    };
  };
}
