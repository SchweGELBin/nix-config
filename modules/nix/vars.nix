{
  cat = {
    accent = "mauve";
    alt = "lavender";
    flavor = "mocha";
  };

  git = {
    repo = "https://github.com/SchweGELBin/nix-config";
  };

  keys = {
    ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtipw/kY5vjH1jeuXWXbmiAxPSSxpqjFx78AlVZ3/Tn";
    wg0 = "DuwZGh9pQ0ES/H/U8BGwTWDEE8hrI/gKuM3cjH6y7T8=";
    wg1 = "Lft8o+wiz7ECT/3sNUX/fNbU2sVdowQEr9mgSJnHghA=";
  };

  theme = {
    cursor = {
      size = 26;
    };
  };

  user = {
    config = "/etc/nixos";
    home = "/home/michi";
    name = "michi";
    stateVersion = "25.05";
  };
}
