{ config, lib, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    clipboard.providers.wl-copy.enable = true;
    defaultEditor = true;
    enableMan = true;

    globals = {
      mapleader = " ";
    };

    package = pkgs.neovim-unwrapped;

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };

    plugins = {
      bufferline.enable = true;
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "buffer"; }
          { name = "luasnip"; }
          { name = "nvim_lsp"; }
          { name = "path"; }
        ];
      };
      lualine.enable = true;
      luasnip.enable = true;
      lsp = {
        enable = true;
        servers = {
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
            cargoPackage = pkgs.cargo;
            package = pkgs.rust-analyzer;
            rustcPackage = pkgs.rustc;
          };
        };
      };
      lsp-format = {
        enable = true;
        lspServersToEnable = "all";
      };
      oil.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
    };

    type = "lua";
    viAlias = true;
    vimAlias = true;
  };
}
