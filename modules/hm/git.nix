{ config, lib, ... }:
let
  cfg = config.git;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      extraConfig = {
        http.postBuffer = 524288000;
        init.defaultBranch = "main";
      };
      lfs.enable = true;
      maintenance.enable = true;
      riff.enable = true;
      signing = {
        format = "ssh";
        key = "${vars.user.home}/.ssh/github_signing-key";
        signByDefault = true;
      };
      userEmail = vars.git.email;
      userName = vars.git.name;
    };
  };

  options = {
    git.enable = lib.mkEnableOption "Enable Git";
  };
}
