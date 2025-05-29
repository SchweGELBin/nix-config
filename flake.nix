{
  description = "SchweGELBin's nix-config flake";

  inputs = {
    #nixos-patch.url = "github:SchweGELBin/nixpkgs/nixos-unstable";
    #nixos-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixos-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs.follows = "nixos-unstable";
    systems.url = "github:nix-systems/default-linux";

    catppuccin = {
      #url = "github:catppuccin/nix";
      url = "github:SchweGELBin/catppuccin-nix/patch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catspeak = {
      url = "github:SchweGELBin/catspeak";
      inputs.nixpkgs.follows = "nixpkgs";
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

    mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
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
