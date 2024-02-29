{ config, pkgs, inputs, ... }:

{
  home.username = "michi";
  home.homeDirectory = "/home/michi";
  programs.home-manager.enable = true;

  home.stateVersion = "23.11"; 
 
  imports = [
   ./modules/default.nix 
   inputs.nix-colors.homeManagerModules.default
  ]; 

  colorScheme = inputs.nix-colors.colorSchemes.catppuccin-macchiato; 
}
