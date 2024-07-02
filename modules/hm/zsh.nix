let
  vars = import ../nix/vars.nix;
in
{
  home.file.".zshrc".text = ''
    # Lines configured by zsh-newuser-install
    HISTFILE=~/.histfile
    HISTSIZE=1000
    SAVEHIST=1000
    bindkey -v
    # End of lines configured by zsh-newuser-install
    # The following lines were added by compinstall
    zstyle :compinstall filename '${vars.user.home}/.zshrc'

    autoload -Uz compinit
    compinit
    # End of lines added by compinstall

    # Custom variables
    export EDITOR="hx"
    export SUDO_EDITOR="hx"
    # End of Custom variables

    # Custom aliases
    alias ff="fastfetch"
    alias prefetch="nix-prefetch-url --unpack"
    alias svi="sudoedit"
    alias search-file="find . -name"
    alias search-text="grep -Rnwe"
    alias vi="$EDITOR"
    # End of Custom aliases
  '';
}
