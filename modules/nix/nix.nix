{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.nix;
  vars = import ../vars.nix;
in
{
  imports = [ inputs.nur.nixosModules.default ];

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
          "https://nix-community.cachix.org"
        ]
        ++ lib.optional (
          config.sys.pkgs.home.enable && config.sys.pkgs.home.wm == "hyprland"
        ) "https://hyprland.cachix.org";
        trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
        android_sdk.accept_license = true;
        cudaSupport = cfg.cuda.enable;
        nvidia.acceptLicense = true;
      };
      overlays = [
        inputs.fenix.overlays.default
        inputs.firefox-addons.overlays.default
      ]
      ++ lib.optional cfg.olmoverlay.enable (
        final: prev: {
          olm = prev.olm.overrideAttrs (previousAttrs: {
            meta.knownVulnerabilities = [ ];
          });
        }
      );
    };

    nur = {
      cache.enable = true;
      overlay.enable = true;
    };

    system.stateVersion = vars.user.stateVersion;
  };

  options = {
    sys.nix = {
      enable = lib.mkEnableOption "Enable Nix";
      cuda.enable = lib.mkEnableOption "Enable CUDA";
      gc.enable = lib.mkEnableOption "Enable automatic garbage collection";
      olmoverlay.enable = lib.mkEnableOption "Enable Olm overlay: Remove insecure warning";
    };
  };
}
