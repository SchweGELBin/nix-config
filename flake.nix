{

  description = "SchweGELBin's nix-config flake";

  inputs = {
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs.follows = "nixpkgs-unstable";
    systems.url = "github:nix-systems/default-linux";

    hyprlang = {
      url = "github:hyprwm/hyprlang";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.hyprlang.follows = "hyprlang";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.hyprlang.follows = "hyprlang";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.hyprlang.follows = "hyprlang";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.hyprlang.follows = "hyprlang";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    nix-direnv = {
      url = "github:nix-community/nix-direnv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations.default = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.catppuccin.nixosModules.catppuccin
        ];
      };
    };
}
