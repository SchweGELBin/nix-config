{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  vars = import ../nix/vars.nix;
in
{
  imports = [ ./devshells ];

  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      config = {
        whitelist.prefix = [ "${vars.user.home}" ];
      };
      package = pkgs.direnv;
      enableBashIntegration = false;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
        package = inputs.nix-direnv.packages.${pkgs.system}.nix-direnv;
      };
    };
  };

  options = {
    direnv.enable = lib.mkEnableOption "Enable Direnv";
  };
}
