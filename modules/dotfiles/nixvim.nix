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
      alpha = {
        enable = true;
        iconsEnabled = true;
        layout = [ ];
        theme = "dashboard";
      };
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
      lint = {
        enable = true;
        linters = { };
      };
      lualine.enable = true;
      luasnip.enable = true;
      lsp = {
        enable = true;
        servers = {
          rust-analyzer = {
            enable = false;
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
      rustaceanvim = {
        enable = true;
        rustAnalyzerPackage = pkgs.rust-analyzer;
      };
      telescope.enable = true;
      treesitter.enable = true;
    };

    type = "lua";
    viAlias = true;
    vimAlias = true;
  };
}
