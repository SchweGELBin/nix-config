{ config, lib, ... }:
let
  cfg = config.account;
  vars = import ../vars.nix;

  prettyName = lib.toSentenceCase vars.user.name;
  dav-remote = {
    passwordCommand = "";
    url = "https://dav.${vars.my.domain}/";
    userName = prettyName;
  };
  thunderbird = {
    enable = config.thunderbird.enable;
    profiles = [ vars.user.name ];
  };
in
{
  config = lib.mkIf cfg.enable {
    accounts = {
      calendar.accounts.${vars.user.name} = {
        primary = true;
        primaryCollection = true;
        remote = dav-remote // {
          type = "caldav";
        };
        inherit thunderbird;
      };
      contact.accounts.${vars.user.name} = {
        remote = dav-remote // {
          type = "carddav";
        };
        inherit thunderbird;
      };
      email.accounts.${vars.user.name} = {
        address = "master@${vars.my.domain}";
        imap = {
          host = "mail.${vars.my.domain}";
          tls.enable = true;
        };
        primary = true;
        realName = prettyName;
        signature = {
          showSignature = "append";
          text = "- ${prettyName}\nHave a great day!";
        };
        smtp = {
          host = "mail.${vars.my.domain}";
          tls.enable = true;
        };
        inherit thunderbird;
        userName = prettyName;
      };
    };
  };

  options = {
    account.enable = lib.mkEnableOption "Enable Account";
  };
}
