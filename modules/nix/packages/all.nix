{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    cachix
    cmake
    gcc
  ];

  programs = {
    java.enable = true;
    zsh.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  services = {
    openssh.enable = true;
  };
}
