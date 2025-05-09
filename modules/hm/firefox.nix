{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.firefox;
  vars = import ../nix/vars.nix;

  icons = "${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16";
  invidious = "https://yewtu.be";
  piped = "https://piped.yt";
  searx = "https://opnxng.com";
in
{
  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
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
        bookmarks = {
          force = true;
          settings = [
            {
              name = "Home Manager Options";
              url = "https://nix-community.github.io/home-manager/options.xhtml";
            }
          ];
        };
        extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [
          behave
          darkreader
          firefox-color
          redirector
          skip-redirect
          ublock-origin
        ];
        extraConfig = "";
        id = 0;
        search = {
          default = "ddg";
          engines = {
            "bing".metaData.hidden = true;
            "ddg".metaData.hidden = false;
            "Crates" = {
              definedAliases = [ "@cr" ];
              icon = "${icons}/actions/folder-open.svg";
              urls = [ { template = "https://crates.io/search?q={searchTerms}"; } ];
            };
            "Icons" = {
              definedAliases = [ "@ic" ];
              icon = "${icons}/emotes/face-cool.svg";
              urls = [ { template = "https://www.nerdfonts.com/cheat-sheet?q={searchTerms}"; } ];
            };
            "GitHub" = {
              definedAliases = [ "@gh" ];
              icon = "${icons}/apps/github.svg";
              urls = [ { template = "https://github.com/search?q={searchTerms}"; } ];
            };
            "google".metaData.hidden = true;
            "Nix Packages" = {
              definedAliases = [ "@np" ];
              icon = "${icons}/apps/distributor-logo-nixos.svg";
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
              icon = "${icons}/apps/distributor-logo-nixos.svg";
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
              icon = "${icons}/apps/distributor-logo-nixos.svg";
              urls = [ { template = "https://wiki.nixos.org/index.php?search={searchTerms}"; } ];
            };
            "Piped" = {
              definedAliases = [ "@pd" ];
              icon = "${icons}/actions/im-youtube.svg";
              urls = [ { template = "${piped}/results?search_query={searchTerms}"; } ];
            };
            "Searx" = {
              definedAliases = [ "@sx" ];
              icon = "${icons}/actions/edit-find.svg";
              urls = [ { template = "${searx}/search?q={searchTerms}"; } ];
            };
            "Startpage" = {
              definedAliases = [ "@sp" ];
              icon = "${icons}/actions/edit-find.svg";
              urls = [ { template = "https://www.startpage.com/search?q={searchTerms}"; } ];
            };
            "wikipedia".metaData.hidden = true;
            "Yewtube" = {
              definedAliases = [ "@yt" ];
              icon = "${icons}/actions/im-youtube.svg";
              urls = [ { template = "${invidious}/search?q={searchTerms}"; } ];
            };
          };
          force = true;
          order = [ ];
          privateDefault = "ddg";
        };
        settings = {
          "app.normandy.api_url" = "";
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "breakpad.reportURL" = "";
          "browser.aboutConfig.showWarning" = false;
          "browser.cache.disk.enable" = false;
          "browser.contentanalysis.default_allow" = false;
          "browser.contentanalysis.default_result" = 0;
          "browser.contentanalysis.enabled" = false;
          "browser.contentblocking.category" = "strict";
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
          "browser.discovery.enabled" = false;
          "browser.display.use_system_colors" = false;
          "browser.download.always_ask_before_handling_new_types" = true;
          "browser.download.alwaysOpenPanel" = false;
          "browser.download.manager.addToRecentDocs" = false;
          "browser.download.start_downloads_in_tmp_dir" = true;
          "browser.download.useDownloadDir" = false;
          "browser.formfill.enable" = false;
          "browser.helperApps.deleteTempFileOnExit" = true;
          "browser.link.open_newwindow" = 3;
          "browser.link.open_newwindow.restriction" = 0;
          "browser.messaging-system.whatsNewPanel.enabled" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.enabled" = false;
          "browser.ping-centre.telemetry" = false;
          "browser.places.speculativeConnect.enabled" = false;
          "browser.privatebrowsing.forceMediaMemoryCache" = true;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.search.separatePrivateDefault" = true;
          "browser.search.separatePrivateDefault.ui.enabled" = true;
          "browser.search.suggest.enabled" = false;
          "browser.sessionstore.privacy_level" = 2;
          "browser.shell.shortcutFavicons" = false;
          "browser.shopping.experience2023.enabled" = false;
          "browser.startup.homepage" = "about:blank";
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.startup.page" = 0;
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.tabs.searchclipboardfor.middleclick" = false;
          "browser.uitour.enabled" = false;
          "browser.urlbar.addons.featureGate" = false;
          "browser.urlbar.fakespot.featureGate" = false;
          "browser.urlbar.mdn.featureGate" = false;
          "browser.urlbar.pocket.featureGate" = false;
          "browser.urlbar.quicksuggest.enabled" = false;
          "browser.urlbar.showSearchTerms.enabled" = false;
          "browser.urlbar.speculativeConnect.enabled" = false;
          "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
          "browser.urlbar.suggest.quicksuggest.sponsored" = false;
          "browser.urlbar.suggest.searches" = false;
          "browser.urlbar.trending.featureGate" = false;
          "browser.urlbar.weather.featureGate" = false;
          "browser.urlbar.yelp.featureGate" = false;
          "browser.xul.error_pages.expert_bad_cert" = true;
          "captivedetect.canonicalURL" = "";
          "clipboard.autocopy" = false;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "devtools.debugger.remote-enabled" = false;
          "dom.disable_window_move_resize" = true;
          "dom.security.https_only_mode_send_http_background_request" = false;
          "dom.security.https_only_mode" = true;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "extensions.blocklist.enabled" = true;
          "extensions.enabledScopes" = 5;
          "extensions.getAddons.showPane" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "extensions.postDownloadThirdPartyPrompt" = false;
          "extensions.quarantinedDomains.enabled" = true;
          "extensions.webcompat.enable_shims" = true;
          "extensions.webcompat-reporter.enabled" = false;
          "font.name.serif.x-western" = "DejaVu Sans";
          "geo.provider.ms-windows-location" = false;
          "geo.provider.use_corelocation" = false;
          "geo.provider.use_geoclue" = false;
          "media.memory_cache_max_size" = 65536;
          "media.peerconnection.ice.default_address_only" = true;
          "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
          "middlemouse.paste" = false;
          "network.auth.subresource-http-auth-allow" = 1;
          "network.captive-portal-service.enabled" = false;
          "network.connectivity-service.enabled" = false;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.dns.disablePrefetch" = true;
          "network.dns.skipTRR-when-parental-control-enabled" = false;
          "network.file.disable_unc_paths" = true;
          "network.gio.supported-protocols" = "";
          "network.http.referer.spoofSource" = false;
          "network.http.referer.XOriginTrimmingPolicy" = 2;
          "network.http.speculative-parallel-limit" = 0;
          "network.IDN_show_punycode" = true;
          "network.predictor.enabled" = false;
          "network.predictor.enable-prefetch" = false;
          "network.prefetch-next" = false;
          "network.proxy.socks_remote_dns" = true;
          "pdfjs.disabled" = false;
          "pdfjs.enableScripting" = false;
          "permissions.manager.defaultsUrl" = "";
          "privacy.clearHistory.cache" = true;
          "privacy.clearHistory.cookiesAndStorage" = false;
          "privacy.clearHistory.historyFormDataAndDownloads" = true;
          "privacy.clearOnShutdown.cache" = true;
          "privacy.clearOnShutdown.cookies" = true;
          "privacy.clearOnShutdown.downloads" = true;
          "privacy.clearOnShutdown.formdata" = true;
          "privacy.clearOnShutdown.history" = true;
          "privacy.clearOnShutdown.offlineApps" = true;
          "privacy.clearOnShutdown.sessions" = true;
          "privacy.clearOnShutdown_v2.cache" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
          "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
          "privacy.clearSiteData.cache" = true;
          "privacy.clearSiteData.cookiesAndStorage" = false;
          "privacy.clearSiteData.historyFormDataAndDownloads" = true;
          "privacy.cpd.cache" = true;
          "privacy.cpd.cookies" = false;
          "privacy.cpd.formdata" = true;
          "privacy.cpd.history" = true;
          "privacy.cpd.offlineApps" = false;
          "privacy.cpd.sessions" = true;
          "privacy.firstparty.isolate" = false;
          "privacy.resistFingerprinting.block_mozAddonManager" = true;
          "privacy.sanitize.sanitizeOnShutdown" = true;
          "privacy.sanitize.timeSpan" = 0;
          "privacy.spoof_english" = 1;
          "privacy.userContext.enabled" = true;
          "privacy.userContext.ui.enabled" = true;
          "privacy.window.maxInnerHeight" = 900;
          "privacy.window.maxInnerWidth" = 1600;
          "security.cert_pinning.enforcement_level" = 2;
          "security.dialog_enable_delay" = 1000;
          "security.family_safety.mode" = 0;
          "security.OCSP.enabled" = 1;
          "security.OCSP.require" = true;
          "security.pki.crlite_mode" = 2;
          "security.remote_settings.crlite_filters.enabled" = true;
          "security.ssl.require_safe_negotiation" = true;
          "security.ssl.treat_unsafe_negotiation_as_broken" = true;
          "security.tls.enable_0rtt_data" = false;
          "security.tls.version.enable-deprecated" = false;
          "signon.autofillForms" = false;
          "signon.formlessCapture.enabled" = false;
          "toolkit.coverage.endpoint.base" = "";
          "toolkit.coverage.opt-out" = true;
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.coverage.opt-out" = true;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.winRegisterApplicationRestart" = false;
          "webchannel.allowObject.urlWhitelist" = "";
          "widget.non-native-theme.enabled" = true;
          "widget.non-native-theme.use-theme-accent" = false;
        };
      };
    };
  };

  options = {
    firefox.enable = lib.mkEnableOption "Enable FireFox";
  };
}
