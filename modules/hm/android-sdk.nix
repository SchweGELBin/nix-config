{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.android-sdk;

  androidsdk = pkgs.androidenv.androidPkgs.androidsdk;
in
{
  config = lib.mkIf cfg.enable {
    home = {
      packages = [ androidsdk ];
      sessionVariables = {
        ANDROID_HOME = androidsdk + "/libexec/android-sdk";
        NDK_HOME = "$ANDROID_HOME/ndk-bundle";
      };
    };
  };

  options = {
    android-sdk.enable = lib.mkEnableOption "Enable Android SDK";
  };
}
