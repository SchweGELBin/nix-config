{
  config,
  inputs,
  pkgs,
  ...
}:
let
  vars = import ../nix/vars.nix;
in
{
  programs.nixvim = {
    enable = true;
    clipboard.providers.wl-copy.enable = true;
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = vars.cat.flavor;
        transparent_background = true;
      };
    };
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
      dap.enable = true;
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
      nvim-tree.enable = true;
      oil.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
    };

    type = "lua";
    viAlias = true;
    vimAlias = true;
  };
}
