{ config, lib, ... }:
let
  cfg = config.git;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        lfs.enable = true;
        maintenance.enable = true;
        signing = {
          format = "ssh";
          key = "${vars.user.home}/.ssh/github_signing-key";
          signByDefault = true;
        };
        settings = {
          http.postBuffer = 524288000;
          init.defaultBranch = "main";
          user = {
            email = vars.git.email;
            name = vars.git.name;
          };
        };
      };
      riff = {
        enable = true;
        enableGitIntegration = true;
      };
    };
  };

  options = {
    git.enable = lib.mkEnableOption "Enable Git";
  };
}
