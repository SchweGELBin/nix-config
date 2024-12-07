{
  config,
  lib,
  pkgs,
  ...
}:
let
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf config.vesktop.enable {
    home.packages = with pkgs; [ vesktop ];
    home.file.".config/vesktop/settings/quickCss.css".text =
      "@import url(https://catppuccin.github.io/discord/dist/catppuccin-${vars.cat.flavor}-${vars.cat.accent}.theme.css);";
  };

  options = {
    vesktop.enable = lib.mkEnableOption "Enable Vesktop";
  };
}
