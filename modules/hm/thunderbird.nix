{ config, lib, ... }:
let
  cfg = config.thunderbird;
  vars = import ../nix/vars.nix;
in
{
  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles.${vars.user.name} = {
        isDefault = true;
        settings = {
          "beacon.enabled" = false;
          "extensions.activeThemeID" = "default-theme@mozilla.org";
          "gfx.downloadable_fonts.enabled" = false;
          "layout.css.visited_links_enabled" = false;
          "mail.inline_attachments" = false;
          "mailnews.display.html_as" = 1;
          "mailnews.display.prefer_plaintext" = true;
          "media.hardware-video-decoding.enabled" = false;
          "network.cookie.cookieBehavior" = 2;
          "network.http.referer.XOriginPolicy" = 2;
          "network.http.sendRefererHeader" = 0;
          "network.IDN_show_punycode" = true;
          "security.family_safety.mode" = 0;
        };
      };
    };
  };

  options = {
    thunderbird.enable = lib.mkEnableOption "Enable Thunderbird";
  };
}
