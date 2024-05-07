{
description = "SchweGELBin's nix-config flake";

inputs = {
  nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
  nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

  nixpkgs.follows = "nixpkgs-unstable";
  systems.url = "github:nix-systems/default-linux";

  hyprlang = {
    url = "github:hyprwm/hyprlang";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.systems.follows = "systems";
  };

  disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  hyprland = {
    url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.hyprlang.follows = "hyprlang";
  }; 

  nix-colors = {
    url = "github:misterio77/nix-colors";
  };
};

outputs = { nixpkgs, ... } @inputs:
{
  nixosConfigurations.default = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      ./configuration.nix

      inputs.disko.nixosModules.default
      (import ./disko.nix { device = "/dev/nvme0n1"; })
    ];
  };
};
}
