{ config, pkgs, inputs, ... }:

{
  home.username = "michi";
  home.homeDirectory = "/home/michi";
  programs.home-manager.enable = true;

  home.stateVersion = "23.11"; 
 
  imports = [
   ./modules/default.nix
  ];
}
