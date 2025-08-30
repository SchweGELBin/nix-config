{
  config,
  inputs,
  lib,
  ...
}:
let
  cfg = config.sys.disko;
in
{
  imports = [ inputs.disko.nixosModules.default ];

  config = lib.mkIf cfg.enable {
    disko.devices.disk.main = {
      device = cfg.device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              settings.allowDiscards = true;
              subvolumes = {
                "/root" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/home" = {
                  mountpoint = "/home";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/log" = {
                  mountpoint = "/var/log";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/persist" = {
                  mountpoint = "/persist";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/swap" = {
                  mountpoint = "/swap";
                  swap.swapfile.size = "20M";
                };
              };
            };
          };
        };
      };
    };
    fileSystems = {
      "/persist".neededForBoot = true;
      "/var/log".neededForBoot = true;
    };
  };

  options = {
    sys.disko = {
      enable = lib.mkEnableOption "Enable Disko";
      device = lib.mkOption {
        description = "Disko Device";
        type = lib.types.str;
      };
    };
  };
}
