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
        cleanup = "nix-collect-garbage -d";
        icat = "kitten icat";
        ff = "fastfetch";
        git-ssh-add = "ssh-add ${vars.user.home}/.ssh/github_authentication-key";
        git-ssh-rm = "ssh-add -D";
        prefetch = "nix-prefetch-url --unpack";
        search-file = "find . -name";
        search-text = "grep -Rne";
        search-word = "grep -Rnwe";
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
