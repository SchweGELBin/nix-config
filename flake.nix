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

  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  hyprpicker = {
    url = "github:hyprwm/hyprpicker";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  hyprland = {
    url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.hyprlang.follows = "hyprlang";
    inputs.systems.follows = "systems";
  };

  hyprlock = {
    url = "github:hyprwm/Hyprlock";
    inputs.nixpkgs.follows = "nixpkgs"; 
    inputs.hyprlang.follows = "hyprlang";
    inputs.systems.follows = "systems";
  };

  hyprpaper = {
    url = "github:hyprwm/hyprpaper";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.hyprlang.follows = "hyprlang";
    inputs.systems.follows = "systems";
  };

  stylix = {
    url = "github:danth/stylix";
  };
};

outputs = { nixpkgs, ... } @inputs:
{
  nixosConfigurations.default = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [
      ./configuration.nix

      inputs.home-manager.nixosModules.default
      inputs.stylix.nixosModules.stylix
    ];
  };
};
}
