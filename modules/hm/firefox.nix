{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.firefox;
  vars = import ../vars.nix;

  icons = "${pkgs.papirus-icon-theme}/share/icons/Papirus/16x16";
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
        DisplayBookmarksToolbar = "newtab";
        DisplayMenuBar = "never";
        DontCheckDefaultBrowser = true;
        DownloadDirectory = "\${home}/Downloads";
        NoDefaultBookmarks = false;
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
              name = "ALL";
              toolbar = true;
              bookmarks = [
                {
                  name = "Michi";
                  bookmarks = [
                    {
                      name = "GitHub";
                      url = "https://github.com/SchweGELBin";
                    }
                    {
                      name = "Home";
                      url = "https://www.${vars.my.domain}";
                    }
                  ];
                }
                {
                  name = "Other";
                  bookmarks = [
                    {
                      name = "Archive";
                      url = "https://web.archive.org/save";
                    }
                    {
                      name = "HM Options";
                      url = "https://nix-community.github.io/home-manager/options.xhtml";
                    }
                  ];
                }
              ];
            }
          ];
        };
        extensions = {
          force = true;
          packages =
            with inputs.firefox-addons.packages.${pkgs.system};
            [ ]
            ++ lib.optionals cfg.extensions.behave.enable [ behave ]
            ++ lib.optionals cfg.extensions.darkreader.enable [ darkreader ]
            ++ lib.optionals cfg.extensions.firefox-color.enable [ firefox-color ]
            ++ lib.optionals cfg.extensions.redirector.enable [ redirector ]
            ++ lib.optionals cfg.extensions.skip-redirect.enable [ skip-redirect ]
            ++ lib.optionals cfg.extensions.stylus.enable [ stylus ]
            ++ lib.optionals cfg.extensions.ublock-origin.enable [ ublock-origin ];
          settings = {
            "FirefoxColor@mozilla.com".settings = lib.mkIf cfg.extensions.firefox-color.enable {
              firstRunDone = true;
            };
            "skipredirect@sblask".settings = lib.mkIf cfg.extensions.skip-redirect.enable {
              blacklist = [
                "/abp"
                "/account"
                "/adfs"
                "/auth"
                "/cookie"
                "/download"
                "/login"
                "/logoff"
                "/logon"
                "/logout"
                "/oauth"
                "/openid"
                "/pay"
                "/preference"
                "/profile"
                "/register"
                "/saml"
                "/signin"
                "/signoff"
                "/signon"
                "/signout"
                "/signup"
                "/sso"
                "/subscribe"
                "/unauthenticated"
                "/verification"
                "https://external-content.duckduckgo.com"
                "https://web.archive.org/web"
              ];
            };
          };
        };
        id = 0;
        search = {
          default = "ddg";
          engines = {
            "Archive" = {
              definedAliases = [ "@ar" ];
              icon = "${icons}/actions/archive.svg";
              urls = [ { template = "https://web.archive.org/web/*/{searchTerms}"; } ];
            };
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
            "HM Options" = {
              definedAliases = [ "@hm" ];
              icon = "${icons}/apps/distributor-logo-nixos.svg";
              urls = [
                { template = "https://home-manager-options.extranix.com/?release=master&query={searchTerms}"; }
              ];
            };
            "Nix Packages" = {
              definedAliases = [ "@np" ];
              icon = "${icons}/apps/distributor-logo-nixos.svg";
              urls = [ { template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; } ];
            };
            "Nix Options" = {
              definedAliases = [ "@no" ];
              icon = "${icons}/apps/distributor-logo-nixos.svg";
              urls = [ { template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}"; } ];
            };
            "NixOS Wiki" = {
              definedAliases = [ "@nw" ];
              icon = "${icons}/apps/distributor-logo-nixos.svg";
              urls = [ { template = "https://wiki.nixos.org/w/index.php?search={searchTerms}"; } ];
            };
            "PeerTube" = {
              definedAliases = [ "@pt" ];
              icon = "${icons}/actions/media-playback-playing.svg";
              urls = [ { template = "https://pt.${vars.my.domain}/search?search={searchTerms}"; } ];
            };
            "SearXNG" = {
              definedAliases = [ "@sx" ];
              icon = "${icons}/actions/edit-find.svg";
              urls = [ { template = "https://searx.${vars.my.domain}/search?q={searchTerms}"; } ];
            };
            "Startpage" = {
              definedAliases = [ "@sp" ];
              icon = "${icons}/actions/edit-find.svg";
              urls = [ { template = "https://www.startpage.com/search?q={searchTerms}"; } ];
            };
            "wikipedia".metaData.hidden = true;
            "Invidious" = {
              definedAliases = [ "@iv" ];
              icon = "${icons}/actions/im-youtube.svg";
              urls = [ { template = "https://iv.${vars.my.domain}/search?q={searchTerms}"; } ];
            };
          };
          force = true;
          privateDefault = "ddg";
        };
        settings = {
          "browser.places.importBookmarksHTML" = true;
          "clipboard.autocopy" = false;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "extensions.autoDisableScopes" = 0;
          "font.name.serif.x-western" = "DejaVu Sans";
          "layout.css.devPixelsPerPx" = 1.2;
          "media.hardwaremediakeys.enabled" = false;
          "middlemouse.paste" = false;
        }
        // lib.optionalAttrs cfg.arkenfox.enable {
          # arkenfox v140
          "app.normandy.api_url" = "";
          "app.normandy.enabled" = false;
          "app.shield.optoutstudies.enabled" = false;
          "breakpad.reportURL" = "";
          "browser.aboutConfig.showWarning" = false;
          "browser.cache.disk.enable" = false;
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
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
          "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.feeds.telemetry" = false;
          "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.telemetry" = false;
          "browser.newtabpage.enabled" = false;
          "browser.places.speculativeConnect.enabled" = false;
          "browser.privatebrowsing.forceMediaMemoryCache" = true;
          "browser.safebrowsing.downloads.remote.enabled" = false;
          "browser.search.separatePrivateDefault" = true;
          "browser.search.separatePrivateDefault.ui.enabled" = true;
          "browser.search.suggest.enabled" = false;
          "browser.sessionstore.privacy_level" = 2;
          "browser.shell.shortcutFavicons" = false;
          "browser.shopping.experience2023.enabled" = false;
          "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
          "browser.startup.homepage_override.mstone" = "ignore";
          "browser.startup.page" = 0;
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.tabs.searchclipboardfor.middleclick" = false;
          "browser.uitour.enabled" = false;
          "browser.urlbar.addons.featureGate" = false;
          "browser.urlbar.amp.featureGate" = false;
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
          "browser.urlbar.wikipedia.featureGate" = false;
          "browser.urlbar.yelp.featureGate" = false;
          "browser.xul.error_pages.expert_bad_cert" = true;
          "captivedetect.canonicalURL" = "";
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "devtools.debugger.remote-enabled" = false;
          "dom.disable_window_move_resize" = true;
          "dom.security.https_only_mode_send_http_background_request" = false;
          "dom.security.https_only_mode" = true;
          "extensions.blocklist.enabled" = true;
          "extensions.enabledScopes" = 5;
          "extensions.getAddons.showPane" = false;
          "extensions.htmlaboutaddons.recommendations.enabled" = false;
          "extensions.postDownloadThirdPartyPrompt" = false;
          "extensions.quarantinedDomains.enabled" = true;
          "extensions.webcompat.enable_shims" = true;
          "extensions.webcompat-reporter.enabled" = false;
          "geo.provider.ms-windows-location" = false;
          "geo.provider.use_corelocation" = false;
          "geo.provider.use_geoclue" = false;
          "media.memory_cache_max_size" = 65536;
          "media.peerconnection.ice.default_address_only" = true;
          "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;
          "network.auth.subresource-http-auth-allow" = 1;
          "network.captive-portal-service.enabled" = false;
          "network.connectivity-service.enabled" = false;
          "network.dns.disablePrefetchFromHTTPS" = true;
          "network.dns.disablePrefetch" = true;
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
          "privacy.clearHistory.browsingHistoryAndDownloads" = true;
          "privacy.clearHistory.cache" = true;
          "privacy.clearHistory.cookiesAndStorage" = false;
          "privacy.clearHistory.formdata" = true;
          "privacy.clearHistory.historyFormDataAndDownloads" = true;
          "privacy.clearOnShutdown_v2.browsingHistoryAndDownloads" = true;
          "privacy.clearOnShutdown_v2.cache" = true;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = true;
          "privacy.clearOnShutdown_v2.downloads" = true;
          "privacy.clearOnShutdown_v2.formdata" = true;
          "privacy.clearOnShutdown_v2.historyFormDataAndDownloads" = true;
          "privacy.clearSiteData.browsingHistoryAndDownloads" = true;
          "privacy.clearSiteData.cache" = true;
          "privacy.clearSiteData.cookiesAndStorage" = false;
          "privacy.clearSiteData.formdata" = true;
          "privacy.clearSiteData.historyFormDataAndDownloads" = true;
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
          "security.csp.reporting.enabled" = false;
          "security.dialog_enable_delay" = 1000;
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
          "widget.non-native-theme.use-theme-accent" = false;
        };
      };
    };
  };

  options = {
    firefox = {
      enable = lib.mkEnableOption "Enable FireFox";
      arkenfox.enable = lib.mkEnableOption "Enable FireFox arkenfox configurations";
      extensions = {
        behave.enable = lib.mkEnableOption "Enable FireFox security extension: behave";
        darkreader.enable = lib.mkEnableOption "Enable FireFox style extension: darkreader";
        firefox-color.enable = lib.mkEnableOption "Enable FireFox style extension: firefox-color";
        redirector.enable = lib.mkEnableOption "Enable FireFox security extension: redirector";
        skip-redirect.enable = lib.mkEnableOption "Enable FireFox security extension: skip-redirect";
        stylus.enable = lib.mkEnableOption "Enable FireFox style extension: stylus";
        ublock-origin.enable = lib.mkEnableOption "Enable FireFox security extension: ublock-origin";
      };
    };
  };
}
