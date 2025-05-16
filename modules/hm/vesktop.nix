{ config, lib, ... }:
let
  cfg = config.vesktop;
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
      vencord.settings = {
        autoUpdate = false;
        autoUpdateNotification = false;
        transparent = false;
        plugins = {
          CustomRPC = {
            enabled = true;
            appID = "1372946876575387759";
            appName = "Foxi's Adventure";
            buttonOneText = "Download Game";
            buttonOneURL = "https://play.google.com/store/apps/details?id=com.schwegelbin.foxisadventure";
            buttonTwoText = "Homepage";
            buttonTwoURL = "https://milchi.site";
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
    };
  };

  options = {
    vesktop.enable = lib.mkEnableOption "Enable Vesktop";
  };
}
