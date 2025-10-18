{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.security;
  vars = import ../vars.nix;
in
{
  imports = [ inputs.sops-nix.homeModules.default ];

  config = lib.mkIf cfg.enable {
    sops = {
      age.keyFile = "${vars.user.home}/.config/sops/age/keys.txt";
      defaultSopsFile = ../secrets.yaml;
    };
  };

  options = {
    security.enable = lib.mkEnableOption "Enable Security";
  };
}
