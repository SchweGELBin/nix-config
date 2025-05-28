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
    domain = "milchi.site";
    repo = "https://github.com/SchweGELBin/nix-config";
  };

  keys = {
    ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtipw/kY5vjH1jeuXWXbmiAxPSSxpqjFx78AlVZ3/Tn";
    wg0 = "DuwZGh9pQ0ES/H/U8BGwTWDEE8hrI/gKuM3cjH6y7T8=";
    wg1 = "Lft8o+wiz7ECT/3sNUX/fNbU2sVdowQEr9mgSJnHghA=";
    wg2 = "i08NC8TyYYNSiFC8v3aeBKs/joVQ5nZnyBSSdYNZqnY=";
  };

  theme = {
    cursor = {
      size = 24;
    };
  };

  user = {
    config = "/home/michi/nix-config";
    home = "/home/michi";
    hostname = {
      home = "nix";
      server = "mix";
    };
    name = "michi";
    stateVersion = "25.11";
  };
}
