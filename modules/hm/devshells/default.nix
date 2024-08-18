let
  vars = import ../../nix/vars.nix;
  nixp = "use nix ${vars.user.config}/modules/hm/devshells";
in
{
  home.file."android/.envrc".text = "${nixp}/android.nix";
  home.file."rust/cli/.envrc".text = "${nixp}/rust.nix";
  home.file."rust/egui/.envrc".text = ''
    ${nixp}/egui.nix
    ${nixp}/rust.nix
  '';
  home.file."rust/tauri/.envrc".text = ''
    ${nixp}/rust.nix
    ${nixp}/tauri.nix
  '';
}
