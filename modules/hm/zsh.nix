{ config, lib, ... }:
let
  cfg = config.zsh;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
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
        ipc = "curl -4 ifconfig.me && echo && curl -6 ifconfig.me && echo";
        ff = "fastfetch";
        git-ssh-add = "ssh-add ${vars.user.home}/.ssh/github_authentication-key";
        git-ssh-rm = "ssh-add -D";
        nix-prefetch-unpack = "nix-prefetch-url --unpack";
        npm = "pnpm";
        search-file = "find . -name";
        search-text = "grep -Rne";
        search-word = "grep -Rnwe";
        ssh = "kitten ssh";
        svi = "sudoedit";
        vi = "$EDITOR";
        vcp = "scp -i ${vars.user.home}/.ssh/mix";
        vps = "kitten ssh -i ${vars.user.home}/.ssh/mix ${vars.user.name}@${vars.my.domain}";
      };
      syntaxHighlighting.enable = true;
    };
  };

  options = {
    zsh.enable = lib.mkEnableOption "Enable Zsh";
  };
}
