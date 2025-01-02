{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wireguard-tools
  ];

  programs = {
    htop.enable = true;
  };
}
