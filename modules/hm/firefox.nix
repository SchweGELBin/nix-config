{
  pkgs,
  config,
  inputs,
  ...
}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    policies = {
      AllowedDomainsForApps = "";
      AppAutoUpdate = false;
      AppUpdateURL = "https://localhost/";
      AutofillAddressEnabled = false;
      AutofillCreditCardEnabled = false;
      BackgroundAppUpdate = false;
      DefaultDownloadDirectory = "\${home}/Downloads";
      DisableAccounts = true;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxScreenshots = true;
      DisableFirefoxStudies = true;
      DisableFormHistory = true;
      DisablePocket = true;
      DisablePrivateBrowsing = true;
      DisableProfileImport = true;
      DisableSafeMode = true;
      DisableSystemAddonUpdate = true;
      DisableSetDesktopBackground = false;
      DisableTelemetry = true;
      DisplayBookmarksToolbar = "never";
      DisplayMenuBar = "never";
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      PasswordManagerEnabled = false;
      PrintingEnabled = false;
      PromptForDownloadLocation = true;
      SearchBar = "unified";
      SearchSuggestEnabled = true;
      TranslateEnabled = false;
      UseSystemPrintDialog = true;
      WindowsSSO = false;
    };
    profiles.michi = {
      bookmarks = [ ];
      extensions = with inputs.firefox-addons.packages.${pkgs.system}; [
        darkreader
        ublock-origin
      ];
      extraConfig = "";
      id = 0;
      search = {
        default = "Searx";
        engines = {
          "Bing".metaData.hidden = true;
          "DuckDuckGo".metaData.hidden = true;
          "Icons" = {
            definedAliases = [ "@ic" ];
            urls = [ { template = "https://www.nerdfonts.com/cheat-sheet?q={searchTerms}"; } ];
          };
          "GitHub" = {
            definedAliases = [ "@gh" ];
            urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
          };
          "Google".metaData.hidden = true;
          "Nix Packages" = {
            definedAliases = [ "@np" ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            urls = [
              {
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "packages";
                  }
                ];
                template = "https://search.nixos.org/packages";
              }
            ];
          };
          "Nix Options" = {
            definedAliases = [ "@no" ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            urls = [
              {
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "options";
                  }
                ];
                template = "https://search.nixos.org/options";
              }
            ];
          };
          "NixOS Wiki" = {
            definedAliases = [ "@nw" ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
          };
          "Piped" = {
            definedAliases = [ "@pd" ];
            urls = [ { template = "https://piped.lunar.icu/results?search_query={searchTerms}"; } ];
          };
          "Searx" = {
            definedAliases = [ "@sx" ];
            urls = [ { template = "https://searx.be/search?q={searchTerms}"; } ];
          };
          "Searxng" = {
            definedAliases = [ "@sn" ];
            urls = [ { template = "https://searxng.site/searxng/search?q={searchTerms}"; } ];
          };
          "Wikipedia (en)".metaData.hidden = true;
          "Yewtube" = {
            definedAliases = [ "@yt" ];
            urls = [ { template = "https://yewtu.be/search?q={searchTerms}"; } ];
          };
        };
        force = true;
        order = [ ];
        privateDefault = "Searx";
      };
      settings = {
        "browser.startup.homepage" = "https://searx.be";
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "extensions.autoDisableScopes" = 1;
        "font.name.serif.x-western" = "DejaVu Sans";
        "permissions.default.camera" = 2;
        "permissions.default.geo" = 2;
        "permissions.default.microphone" = 2;
        "permissions.default.desktop-notification" = 2;
        "permissions.default.xr" = 2;
        "privacy.annotate_channels.strict_list.enabled" = true;
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;
      };
      userChrome = "";
      userContent = "";
    };
  };
}
