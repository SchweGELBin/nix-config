{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  vars = import ../nix/vars.nix;
  searx = "https://opnxng.com";
  piped = "https://piped.yt";
  invidious = "https://yewtu.be";
in
{
  config = lib.mkIf config.firefox.enable {
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
        DownloadDirectory = "\${home}/Downloads";
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
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
      profiles.${vars.user.name} = {
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
            "DuckDuckGo".metaData.hidden = false;
            "Crates" = {
              definedAliases = [ "@cr" ];
              urls = [ { template = "https://crates.io/search?q={searchTerms}"; } ];
            };
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
              urls = [ { template = "${piped}/results?search_query={searchTerms}"; } ];
            };
            "Searx" = {
              definedAliases = [ "@sx" ];
              urls = [ { template = "${searx}/search?q={searchTerms}"; } ];
            };
            "Wikipedia (en)".metaData.hidden = true;
            "Yewtube" = {
              definedAliases = [ "@yt" ];
              urls = [ { template = "${invidious}/search?q={searchTerms}"; } ];
            };
          };
          force = true;
          order = [ ];
          privateDefault = "Searx";
        };
        settings = {
          "browser.startup.homepage" = "${searx}";
          "browser.theme.content-theme" = 0;
          "browser.theme.toolbar-theme" = 0;
          "dom.private-attribution.submission.enabled" = false;
          "dom.security.https_only_mode" = true;
          "dom.security.https_only_mode_ever_enabled" = true;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "extensions.autoDisableScopes" = 0;
          "font.name.serif.x-western" = "DejaVu Sans";
          "layout.css.devPixelsPerPx" = 1.2;
          "permissions.default.camera" = 2;
          "permissions.default.geo" = 2;
          "permissions.default.microphone" = 2;
          "permissions.default.desktop-notification" = 2;
          "permissions.default.xr" = 2;
          "places.history.enabled" = false;
          "privacy.annotate_channels.strict_list.enabled" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown.cookies" = true;
          "privacy.clearOnShutdown.formdata" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.sessions" = true;
          "privacy.clearOnShutdown.siteSettings" = true;
          "privacy.donottrackheader.enabled" = true;
          "privacy.globalprivacycontrol.enabled" = true;
          "privacy.history.custom" = true;
        };
        userChrome = "";
        userContent = "";
      };
    };
  };

  options = {
    firefox.enable = lib.mkEnableOption "Enable FireFox";
  };
}
