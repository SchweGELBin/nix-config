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
      dcid.owner = "smoo";
      dctoken.owner = "smoo";
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
            sed -i -e "s/\"SECRET_TOKEN_1\"/\"$(cat ${secrets.smtoken1.path})\"/g" ./settings.json
            sed -i -e "s/\"SECRET_TOKEN_2\"/\"$(cat ${secrets.smtoken2.path})\"/g" ./settings.json
          fi
        '';
        script = ''
          ${pkgs.dotnet-sdk_8}/bin/dotnet run --project ./SMOOS-CS/Server/Server.csproj -c Release
        '';
        serviceConfig = {
          User = "smoo";
          WorkingDirectory = "/var/lib/smoo";
        };
        wantedBy = [ "multi-user.target" ];
      };
      smoos-bot = {
        enable = true;
        preStart = ''
          repo="SMOOS-Bot"
          if [[ ! -d ./$repo ]]; then
            ${pkgs.git}/bin/git clone https://github.com/SchweGELBin/$repo.git
          fi
        '';
        script = ''
          export DISCORD_TOKEN="$(cat ${secrets.dctoken.path})"
          export DISCORD_ID="$(cat ${secrets.dcid.path})"
          export API_TOKEN="$(cat ${secrets.smtoken2.path})"
          export CC="${pkgs.gcc}/bin/gcc"
          export AR="${pkgs.gcc}/bin/ar"
          export RUSTFLAGS="-C linker=$CC"
          export RUSTC="${pkgs.fenix.minimal.rustc}/bin/rustc"
          cd SMOOS-Bot
          ${pkgs.fenix.minimal.cargo}/bin/cargo run -r
        '';
        serviceConfig = {
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
