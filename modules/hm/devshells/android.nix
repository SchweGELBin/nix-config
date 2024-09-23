let
  pkgs = import <nixpkgs> {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  };

  android = {
    composition = pkgs.androidenv.composeAndroidPackages {
      includeNDK = true;
      platformVersions = [ "34" ];
    };
    sdk = android.composition.androidsdk;
  };
in
pkgs.mkShell {
  buildInputs = [ android.sdk ];
  shellHook = ''
    export ANDROID_HOME=${android.sdk}/libexec/android-sdk
    export NDK_HOME=$ANDROID_HOME/ndk-bundle
  '';
}
