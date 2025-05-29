{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.hm-pkgs;
in
{
  imports = [
    ./home.nix
    ./server.nix
  ];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      apksigner
      cmatrix
      file
      ffmpeg
      imagemagick
      inputs.catspeak.packages.${pkgs.system}.default
      mdcat
      neo-cowsay
      pipes-rs
      pwgen
      sops
      unzip
      wget
      zip
    ];

    programs = {
      bash.enable = true;
      bat.enable = true;
      btop.enable = true;
      git-cliff.enable = true;
      home-manager.enable = true;
      zsh.enable = true;
    };
  };

  options = {
    hm-pkgs = {
      enable = lib.mkEnableOption "Enable HM Packages";
      home.enable = lib.mkEnableOption "Enable HM Home Packages";
      server.enable = lib.mkEnableOption "Enable HM Server Packages";
    };
  };
}
