{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.default ];

  config = lib.mkIf config.sys.home-manager.enable {
    home-manager = {
      extraSpecialArgs = { inherit inputs; };
      useGlobalPkgs = true;
    };
  };

  options = {
    sys.home-manager.enable = lib.mkEnableOption "Enable Home Manager";
  };
}
