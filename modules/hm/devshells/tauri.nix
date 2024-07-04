let
  pkgs = import <nixpkgs> { };

  libraries = with pkgs; [
    cairo
    dbus
    gdk-pixbuf
    glib
    gtk3
    librsvg
    libsoup
    openssl_3
    webkitgtk
    webkitgtk_4_1
  ];

  packages = with pkgs; [
    appimagekit
    cargo-tauri
    dbus
    glib
    gtk3
    librsvg
    libsoup
    openssl_3
    pkg-config
    webkitgtk
    webkitgtk_4_1
  ];
in
pkgs.mkShell {
  buildInputs = packages;

  shellHook = ''
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath libraries}:$LD_LIBRARY_PATH
    export XDG_DATA_DIRS=${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:$XDG_DATA_DIRS
    #cargo install create-tauri-app
  '';
}
