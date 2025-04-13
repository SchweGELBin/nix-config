{
  config,
  inputs,
  lib,
  ...
}:
let
  vars = import ./vars.nix;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  config = lib.mkIf config.sys.security.enable {
    security = {
      acme = {
        acceptTerms = true;
        defaults.email = "acme@${vars.my.domain}";
      };
    };

    services.fail2ban.enable = true;

    sops = {
      defaultSopsFile = ../../secrets/mix.yaml;
      age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
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
