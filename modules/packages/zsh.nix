{ config, pkgs, ... }:
{
  home.file.".zshrc".text = ''
    # Lines configured by zsh-newuser-install
    HISTFILE=~/.histfile
    HISTSIZE=1000
    SAVEHIST=1000
    bindkey -v
    # End of lines configured by zsh-newuser-install
    # The following lines were added by compinstall
    zstyle :compinstall filename '/home/michi/.zshrc'

    autoload -Uz compinit
    compinit
    # End of lines added by compinstall

    # The following lines are custom added aliases
    alias ff="fastfetch"
    alias changelog="conventional-changelog -p angular -i CHANGELOG.md -s -r 0"
    # End of custom added lines
  '';
}
