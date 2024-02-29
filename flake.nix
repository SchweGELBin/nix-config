{
description = "SchweGELBin's nix-config flake";
     
inputs = {
  nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  hyprland.url = "github:hyprwm/Hyprland";

  nix-colors.url = "github:misterio77/nix-colors";
};

outputs = { nixpkgs, ... } @inputs:
{
  nixosConfigurations.default = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      ./configuration.nix

      inputs.disko.nixosModules.default
      (import ./disko.nix { device = "/dev/nvme0n1"; })

      inputs.home-manager.nixosModules.default
    ];
  };
};
}
