let
  pkgs = import <nixpkgs> {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  };
  android = {
    composition = pkgs.androidenv.composeAndroidPackages { platformVersions = [ "35" ]; };
    sdk = android.composition.androidsdk;
  };
in
pkgs.mkShell {
  buildInputs = [ android.sdk ];
  shellHook = "export ANDROID_SDK_ROOT=${android.sdk}/libexec/android-sdk";
}
