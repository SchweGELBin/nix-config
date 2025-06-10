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

    sops.secrets = {
      discord_env.owner = "smoo";
      smtoken1.owner = "smoo";
      smtoken2.owner = "smoo";
    };

    systemd.services = {
      smoos = {
        enable = true;
        preStart = ''
          repo="SMOOS-CS"
          if [[ ! -d ./$repo ]]; then
            ${pkgs.git}/bin/git clone https://github.com/SchweGELBin/$repo.git
            cp ./$repo/settings.json .
            sed -i '/JsonApi/{n;s/false/true/}' ./settings.json
            sed -i -e "s/\"SECRET_TOKEN_1\"/\"\$API_TOKEN_PUB\"/g" ./settings.json
            sed -i -e "s/\"SECRET_TOKEN_2\"/\"\$API_TOKEN\"/g" ./settings.json
          fi
        '';
        script = ''
          ${pkgs.dotnet-sdk_8}/bin/dotnet run --project ./SMOOS-CS/Server/Server.csproj -c Release
        '';
        serviceConfig = {
          EnvironmentFile = secrets.smoos_env.path;
          User = "smoo";
          WorkingDirectory = "/var/lib/smoo";
        };
        wantedBy = [ "multi-user.target" ];
      };
      smoos-bot = {
        enable = true;
        script = "${lib.getExe inputs.nur.packages.${pkgs.system}.smoos-bot}";
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
