{
  config,
  lib,
  pkgs,
  ...
}:
let
  android = {
    composition = pkgs.androidenv.composeAndroidPackages {
      includeNDK = true;
      platformVersions = [ "35" ];
    };
    sdk = android.composition.androidsdk;
  };
in
{
  config = lib.mkIf config.android-sdk.enable {
    home = {
      packages = [ android.sdk ];
      sessionVariables = {
        ANDROID_HOME = "${android.sdk}/libexec/android-sdk";
        NDK_HOME = "$ANDROID_HOME/ndk-bundle";
      };
    };
  };

  options = {
    android-sdk.enable = lib.mkEnableOption "Enable Android SDK";
  };
}
