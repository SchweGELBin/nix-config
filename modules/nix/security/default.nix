{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.security;
  vars = import ../../vars.nix;
in
{
  imports = [ inputs.sops-nix.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    security = {
      acme = {
        acceptTerms = true;
        defaults.email = "acme@${vars.my.domain}";
      };
    };

    services.fail2ban.enable = true;

    sops = {
      age.keyFile = "${vars.user.home}/.config/sops/age/keys.txt";
      defaultSopsFile = ./secrets.yaml;
    };

    users = {
      groups.systemd = { };
      users.${vars.user.name}.openssh.authorizedKeys.keys = [ vars.keys.ssh ];
    };
  };

  options = {
    sys.security.enable = lib.mkEnableOption "Enable Server Security";
  };
}
