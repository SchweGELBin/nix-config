{ config, lib, ... }:
let
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf config.direnv.enable {
    programs.direnv = {
      enable = true;
      config.whitelist.prefix = [ "${vars.user.home}" ];
      enableBashIntegration = false;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };

  options = {
    direnv.enable = lib.mkEnableOption "Enable Direnv";
  };
}
