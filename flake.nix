{

  description = "SchweGELBin's nix-config flake";

  inputs = {
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-small.url = "github:nixos/nixpkgs/nixos-unstable-small";

    nixpkgs.follows = "nixos-small";
    systems.url = "github:nix-systems/default-linux";

    catppuccin = {
      url = "github:catppuccin/nix";
    };

    fenix = {
      url = "github:nix-community/fenix/monthly";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs = {
        hyprland.follows = "hyprland";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    hyprsysteminfo = {
      url = "github:hyprwm/hyprsysteminfo";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
      };
    };

    nix-direnv = {
      url = "github:nix-community/nix-direnv";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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
      nixosConfigurations.home = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/home/configuration.nix
        ];
      };
      nixosConfigurations.server = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/server/configuration.nix
        ];
      };
    };
}
