{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.catppuccin;
  vars = import ./vars.nix;
in
{
  imports = [ inputs.catppuccin.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    catppuccin = {
      enable = true;
      accent = vars.cat.accent;
      cache.enable = true;
      flavor = vars.cat.flavor;
    };
  };

  options = {
    sys.catppuccin.enable = lib.mkEnableOption "Enable Catppuccin";
  };
}
