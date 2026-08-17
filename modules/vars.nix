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
    domain = "michi.im";
    repo = {
      git = "git@github.com:SchweGELBin/nix-config";
      https = "https://github.com/SchweGELBin/nix-config";
    };
  };

  keys = {
    gpg = "1FA41751015835B9C3998B33005268D8B1718161";
    ssh = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIpcXGXgaNtsc3enpyEyfS5aJOy35ACEdksT2Xppjb07";
    wgc = "ZJgCSd2LXqZwLrTVXs/KlTJw68yitxGQuOp7Q8qKyFY=";
    wgc2 = "cISNL/g/FM9Ci7VYY9gPgR0CTVRj2Bot4eGsCUnstCw=";
    wgs = "GXdX6z0NwGQsYjWDEj8pJV20ldFBQ4yIFsblp2s8lhc=";
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
