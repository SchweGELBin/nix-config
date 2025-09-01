{ lib, modulesPath, ... }:

{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "sr_mod"
    "usbhid"
    "virtio_pci"
    "virtio_scsi"
    "xhci_pci"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
