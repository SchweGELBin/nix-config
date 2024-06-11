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
    alias prefetch="nix-prefetch-url --unpack"
    # End of custom added lines
  '';
}
