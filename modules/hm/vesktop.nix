{ config, lib, ... }:
let
  cfg = config.vesktop;
  vars = import ../vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    programs.vesktop = {
      enable = true;
      settings = {
        arRPC = true;
        staticTitle = true;
        clickTrayToShowHide = true;
        spellCheckLanguages = [
          "de"
          "en"
        ];
      };
      vencord = {
        settings = {
          arRPC = true;
          autoUpdate = false;
          autoUpdateNotification = false;
          hardwareAcceleration = true;
          hardwareVideoAcceleration = true;
          transparent = false;
          plugins = {
            CustomRPC = {
              enabled = true;
              appID = "1372946876575387759";
              appName = "Foxi's Adventure";
              buttonOneText = "Download Game";
              buttonOneURL = "https://play.google.com/store/apps/details?id=com.schwegelbin.foxisadventure";
              buttonTwoText = "Homepage";
              buttonTwoURL = "https://${vars.my.domain}";
              imageBig = "https://play-lh.googleusercontent.com/SdxJZuzbOXOMv6VnkfyO2Yb_xBw4UII11uTuJmjqJnombs_yUwxG706tRdBFNt73ftym=w480-h960";
            };
            CrashHandler = {
              attemptToPreventCrashes = true;
              attemptToNavigateToHome = false;
            };
            NoTrack.disableAnalytics = true;
            Settings.settingsLocation = "aboveNitro";
          };
        };
        useSystem = true;
      };
    };
  };

  options = {
    vesktop = {
      enable = lib.mkEnableOption "Enable Vesktop";
      vencord.useSystem = lib.mkEnableOption "Enable System Vencord";
    };
  };
}
