{ config, lib, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    clipboard.providers.wl-copy.enable = true;
    defaultEditor = true;
    package = pkgs.neovim-unwrapped;
  };
}
