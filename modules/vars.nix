{
  cat = {
    accent = "mauve";
    alt = "pink";
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
    wgc = "+nIuimwykjLu8JGyJw2U6vOFaeCkF4agedgfxX7Iizs=";
    wgs = "D2hzynxz2/P5GV8tusEniV26jBne2UnJyaReA5d4PHA=";
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
    name = "michi";
    stateVersion = "25.11";
  };
}
