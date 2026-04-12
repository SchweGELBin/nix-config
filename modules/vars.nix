{
  cat = {
    accent = "mauve";
    alt = "pink";
    flavor = "mocha";
  };

  git = {
    email = "schwegelbin@gmail.com";
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
    gpg = "1FA41751015835B9C3998B33005268D8B1718161";
    ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpcXGXgaNtsc3enpyEyfS5aJOy35ACEdksT2Xppjb07";
    wgc = "+nIuimwykjLu8JGyJw2U6vOFaeCkF4agedgfxX7Iizs=";
    wgc2 = "FjlTCwK59t2Edf7BUtT0s7Jg2jmYxleYSGBFnGs5JAY=";
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
    stateVersion = "26.05";
  };
}
