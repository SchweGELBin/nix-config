{
  home.file."android/.envrc".text = "use nix /etc/nixos/modules/hm/devshells/android.nix";
  home.file."rust/cli/.envrc".text = "use nix /etc/nixos/modules/hm/devshells/rust.nix";
  home.file."rust/egui/.envrc".text = ''
    use nix /etc/nixos/modules/hm/devshells/egui.nix
    use nix /etc/nixos/modules/hm/devshells/rust.nix
  '';
  home.file."rust/tauri/.envrc".text = ''
    use nix /etc/nixos/modules/hm/devshells/rust.nix
    use nix /etc/nixos/modules/hm/devshells/tauri.nix
  '';
}
