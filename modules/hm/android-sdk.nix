{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.android-sdk;

  android = {
    composition = pkgs.androidenv.composeAndroidPackages {
      includeNDK = true;
      platformVersions = [ "36" ];
    };
    sdk = android.composition.androidsdk;
  };
in
{
  config = lib.mkIf cfg.enable {
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
