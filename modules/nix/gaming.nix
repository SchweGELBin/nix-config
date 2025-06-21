{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.gaming;
in
{
  imports = [
    inputs.nix-gaming.nixosModules.ntsync
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];

  config = lib.mkIf cfg.enable {
    programs.steam.platformOptimizations.enable = true;
    programs.wine.ntsync.enable = true;
    services.pipewire.lowLatency.enable = true;
  };

  options = {
    sys.gaming.enable = lib.mkEnableOption "Enable Gaming";
  };
}
