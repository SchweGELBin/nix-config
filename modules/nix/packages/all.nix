{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cachix
    cmake
    gcc
  ];
}
