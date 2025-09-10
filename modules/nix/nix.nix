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
        ++ lib.optionals (config.sys.pkgs.home.enable && config.sys.pkgs.home.wm == "hyprland") [
          "https://hyprland.cachix.org"
        ];
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
        nvidia.acceptLicense = true;
      };
      overlays = [ inputs.fenix.overlays.default ];
    };

    nur.cache.enable = true;

    system.stateVersion = vars.user.stateVersion;
  };

  options = {
    sys.nix = {
      enable = lib.mkEnableOption "Enable Nix";
      gc.enable = lib.mkEnableOption "Enable automatic garbage collection";
    };
  };
}
