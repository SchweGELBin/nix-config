{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.vesktop;
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ vesktop ];
    home.file.".config/vesktop/settings/quickCss.css".text =
      "@import url(https://catppuccin.github.io/discord/dist/catppuccin-${vars.cat.flavor}-${vars.cat.accent}.theme.css);";
  };

  options = {
    vesktop.enable = lib.mkEnableOption "Enable Vesktop";
  };
}
