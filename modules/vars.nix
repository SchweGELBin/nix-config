{
  cat = {
    accent = "mauve";
    alt = "lavender";
    flavor = "mocha";
  };

  git = {
    email = "abramjannikmichael06@gmail.com";
    name = "SchweGELBin";
  };

  my = {
    discordid = 494972810100211722;
    domain = "michi.my";
    repo = {
      git = "git@github.com:SchweGELBin/nix-config";
      https = "https://github.com/SchweGELBin/nix-config";
    };
  };

  keys = {
    ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtipw/kY5vjH1jeuXWXbmiAxPSSxpqjFx78AlVZ3/Tn";
    wg0 = "DuwZGh9pQ0ES/H/U8BGwTWDEE8hrI/gKuM3cjH6y7T8=";
    wg1 = "Lft8o+wiz7ECT/3sNUX/fNbU2sVdowQEr9mgSJnHghA=";
    wg2 = "i08NC8TyYYNSiFC8v3aeBKs/joVQ5nZnyBSSdYNZqnY=";
  };

  monitors = {
    first = {
      bit = 10;
      hz = 180;
      res = {
        x = 2560;
        y = 1440;
      };
    };
    second = {
      bit = 10;
      hz = 180;
      res = {
        x = 3440;
        y = 1440;
      };
    };
  };

  theme = {
    cursor = {
      size = 24;
    };
  };

  user = {
    config = "/etc/nixos";
    home = "/home/michi";
    hostname = {
      home = "nix";
      server = "mix";
    };
    name = "michi";
    stateVersion = "25.11";
  };
}
