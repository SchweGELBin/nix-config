{ config, lib, ... }:
let
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "man"
          "sudo"
          "tldr"
        ];
        theme = "ys";
      };
      sessionVariables = {
        EDITOR = "hx";
        SUDO_EDITOR = "hx";
      };
      shellAliases = {
        icat = "kitten icat";
        ff = "fastfetch";
        git-ssh = "ssh-add ${vars.user.home}/.ssh/github_authentication-key";
        prefetch = "nix-prefetch-url --unpack";
        search-file = "find . -name";
        search-text = "grep -Rnwe";
        svi = "sudoedit";
        vi = "$EDITOR";
        vps = "kitten ssh";
      };
      syntaxHighlighting.enable = true;
    };
  };

  options = {
    zsh.enable = lib.mkEnableOption "Enable Zsh";
  };
}
