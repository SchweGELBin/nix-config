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

  imports = [ inputs.nur.homeModules.default ];

  config = lib.mkIf cfg.enable {
    nur.firefox = {
      enable = true;
      extensions.defaultSettings.enable = true;
      profile = vars.user.name;
      settings = {
        clear.enable = cfg.clear.enable;
        harden.enable = cfg.harden.enable;
      };
    };
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
                      url = "https://${vars.my.domain}";
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
                      name = "Nixpkgs Tracker";
                      url = "https://nixpkgs-tracker.ocfox.me";
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
            with pkgs.nur.firefox-addons;
            lib.optional cfg.extensions.behave.enable behave
            ++ lib.optional cfg.extensions.darkreader.enable darkreader
            ++ lib.optional cfg.extensions.firefox-color.enable firefox-color
            ++ lib.optional cfg.extensions.redirector.enable redirector
            ++ lib.optional cfg.extensions.skip-redirect.enable skip-redirect
            ++ lib.optional cfg.extensions.stylus.enable stylus
            ++ lib.optional cfg.extensions.ublock-origin.enable ublock-origin;
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
            "Forgejo" = {
              definedAliases = [ "@fo" ];
              icon = "${icons}/apps/git.svg";
              urls = [ { template = "https://git.${vars.my.domain}/explore/repos?q={searchTerms}"; } ];
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
            "Invidious" = {
              definedAliases = [ "@iv" ];
              icon = "${icons}/actions/im-youtube.svg";
              urls = [ { template = "https://iv.${vars.my.domain}/search?q={searchTerms}"; } ];
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
            "Noogle" = {
              definedAliases = [ "@ng" ];
              icon = "${icons}/apps/distributor-logo-nixos.svg";
              urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
            };
            "PeerTube" = {
              definedAliases = [ "@pt" ];
              icon = "${icons}/actions/media-playback-playing.svg";
              urls = [ { template = "https://pt.${vars.my.domain}/search?search={searchTerms}"; } ];
            };
            "Piped" = {
              definedAliases = [ "@pd" ];
              icon = "${icons}/actions/im-youtube.svg";
              urls = [ { template = "https://pd.${vars.my.domain}/results?search_query={searchTerms}"; } ];
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
            "websurfx" = {
              definedAliases = [ "@ws" ];
              icon = "${icons}/actions/edit-find.svg";
              urls = [ { template = "https://surfx.${vars.my.domain}/search?q={searchTerms}"; } ];
            };
            "Whoogle" = {
              definedAliases = [ "@wh" ];
              icon = "${icons}/actions/edit-find.svg";
              urls = [ { template = "https://whoogle.${vars.my.domain}/search?q={searchTerms}"; } ];
            };
          };
          force = true;
          privateDefault = "ddg";
        };
        settings = {
          "browser.ml.enable" = false;
          "browser.places.importBookmarksHTML" = true;
          "clipboard.autocopy" = false;
          "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
          "extensions.autoDisableScopes" = 0;
          "font.name.serif.x-western" = "DejaVu Sans";
          "layout.css.devPixelsPerPx" = 1.2;
          "media.hardwaremediakeys.enabled" = false;
          "middlemouse.paste" = false;
        };
      };
    };
  };

  options = {
    firefox = {
      enable = lib.mkEnableOption "Enable FireFox";
      clear.enable = lib.mkEnableOption "Enable FireFox cleanup";
      extensions = {
        behave.enable = lib.mkEnableOption "Enable FireFox security extension: behave";
        darkreader.enable = lib.mkEnableOption "Enable FireFox style extension: darkreader";
        firefox-color.enable = lib.mkEnableOption "Enable FireFox style extension: firefox-color";
        redirector.enable = lib.mkEnableOption "Enable FireFox security extension: redirector";
        skip-redirect.enable = lib.mkEnableOption "Enable FireFox security extension: skip-redirect";
        stylus.enable = lib.mkEnableOption "Enable FireFox style extension: stylus";
        ublock-origin.enable = lib.mkEnableOption "Enable FireFox security extension: ublock-origin";
      };
      harden.enable = lib.mkEnableOption "Enable FireFox hardened configurations";
    };
  };
}
