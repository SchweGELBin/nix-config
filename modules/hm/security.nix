{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.security;
in
{
  imports = [ inputs.sops-nix.homeModules.default ];

  config = lib.mkIf cfg.enable {
    sops.defaultSopsFile = ../secrets.yaml;
  };

  options = {
    security.enable = lib.mkEnableOption "Enable Security";
  };
}
