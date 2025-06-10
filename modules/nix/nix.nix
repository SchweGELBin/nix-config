{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nix;
in
{
  config = lib.mkIf cfg.enable {
    nix = {
      gc.automatic = cfg.gc.enable;
      optimise.automatic = true;
      settings = {
        experimental-features = [
          "flakes"
          "nix-command"
        ];
        substituters = [
          "https://cachix.org"
          "https://hyprland.cachix.org"
          "https://nix-community.cachix.org"
        ];
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "schwegelbin.cachix.org-1:Ckh//WCg8vz3W1AzjD/QdYZ4VHA7ZU/q7nXb98IZ+TQ="
        ];
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
        nvidia.acceptLicense = true;
      };
      overlays = [ inputs.fenix.overlays.default ];
    };
  };

  options = {
    sys.nix = {
      enable = lib.mkEnableOption "Enable Nix";
      gc.enable = lib.mkEnableOption "Enable automatic garbage collection";
    };
  };
}
