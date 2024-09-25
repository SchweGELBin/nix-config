{ config, lib, ... }:
let
  vars = import ../../nix/vars.nix;
  nixp = "use nix ${vars.user.config}/modules/hm/devshells";

  cfg = config.devshells;
  enable = cfg.enable;

  android = cfg.android.enable;
  rust = cfg.rust.enable;

  dioxus = rust && cfg.rust.dioxus.enable;
  egui = rust && cfg.rust.egui.enable;
  tauri = rust && cfg.rust.tauri.enable;
in
{
  config = lib.mkIf enable {
    home.file = {
      "android/.envrc" = lib.mkIf android { text = "${nixp}/android.nix"; };
      "rust/cli/.envrc" = lib.mkIf rust { text = "${nixp}/rust.nix"; };
      "rust/dioxus/.envrc" = lib.mkIf dioxus {
        text = ''
          ${nixp}/android.nix
          ${nixp}/rust.nix
          ${nixp}/dioxus.nix
        '';
      };
      "rust/egui/.envrc" = lib.mkIf egui {
        text = ''
          ${nixp}/rust.nix
          ${nixp}/egui.nix
        '';
      };
      "rust/tauri/.envrc" = lib.mkIf tauri {
        text = ''
          ${nixp}/android.nix
          ${nixp}/rust.nix
          ${nixp}/tauri.nix
        '';
      };
    };
  };

  options = {
    devshells = {
      enable = lib.mkEnableOption "Enable Devshells";
      android.enable = lib.mkEnableOption "Enable Android Devshell";
      rust = {
        enable = lib.mkEnableOption "Enable Rust Devshell";
        dioxus.enable = lib.mkEnableOption "Enable Rust dioxus Devshell";
        egui.enable = lib.mkEnableOption "Enable Rust egui Devshell";
        tauri.enable = lib.mkEnableOption "Enable Rust tauri Devshell";
      };
    };
  };
}
