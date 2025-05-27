{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.sys.pkgs;
in
{
  imports = [
    ./home.nix
    ./server.nix
  ];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      cachix
      cmake
      gcc
    ];

    programs = {
      java.enable = true;
      nix-ld.enable = true;
      zsh.enable = true;
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
    };

    services = {
      openssh.enable = true;
    };
  };

  options = {
    sys.pkgs = {
      enable = lib.mkEnableOption "Enable System Packages";
      home.enable = lib.mkEnableOption "Enable System Home Packages";
      server.enable = lib.mkEnableOption "Enable System Server Packages";
    };
  };
}
