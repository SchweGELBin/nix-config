{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.home-manager;
in
{
  imports = [ inputs.home-manager.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
    };
  };

  options = {
    sys.home-manager.enable = lib.mkEnableOption "Enable Home Manager";
  };
}
