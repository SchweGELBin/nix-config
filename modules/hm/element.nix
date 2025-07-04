{ config, lib, ... }:
let
  cfg = config.element;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    programs.element-desktop = {
      enable = true;
      settings = {
        default_server_config."m.homeserver" = {
          base_url = "https://matrix.${vars.my.domain}";
          server_name = vars.my.domain;
        };
        permalink_prefix = "https://element.${vars.my.domain}";
      };
    };
  };

  options = {
    element.enable = lib.mkEnableOption "Enable Element Desktop";
  };
}
