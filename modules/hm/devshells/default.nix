let
  vars = import ../../nix/vars.nix;
  nixp = "use nix ${vars.user.config}/modules/hm/devshells";
in
{
  home.file = {
    "android/.envrc".text = "${nixp}/android.nix";
    "rust/cli/.envrc".text = "${nixp}/rust.nix";
    "rust/egui/.envrc".text = ''
      ${nixp}/egui.nix
      ${nixp}/rust.nix
    '';
    "rust/tauri/.envrc".text = ''
      ${nixp}/android.nix
      ${nixp}/rust.nix
      ${nixp}/tauri.nix
    '';
  };
}
