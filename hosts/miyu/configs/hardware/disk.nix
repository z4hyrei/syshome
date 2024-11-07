{
  config,
  inputs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/nvme0n1";

    content = {
      type = "gpt";

      partitions.BOOT = {
        type = "EF00";
        size = "550M";

        content = {
          type = "filesystem";
          format = "vfat";

          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };

      partitions.LUKS = {
        size = "100%";

        content = {
          type = "luks";
          name = "cryptroot";

          settings = {
            allowDiscards = true;
          };

          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];

            postCreateHook = ''
              mkdir -p /tmp
              MNTPOINT=$(mktemp -d)
              (
                mount -t btrfs -o subvol=/ /dev/mapper/cryptroot "$MNTPOINT"
                trap 'umount "$MNTPOINT" && rm -rf "$MNTPOINT"' EXIT

                btrfs subvolume snapshot -r "$MNTPOINT/rootfs" "$MNTPOINT/rootfs-blank"
              )
            '';

            subvolumes."/rootfs" = {
              mountpoint = "/";
              mountOptions = [
                "compress=zstd"
                "noatime"
              ];
            };

            subvolumes."/nix" = {
              mountpoint = "/nix";
              mountOptions = [
                "compress=zstd"
                "noatime"
              ];
            };

            subvolumes."/swap" = {
              mountpoint = "/.swapvol";
              swap.swapfile.size = "20G";
            };

            subvolumes."/persist" = {
              mountpoint = "/persist";
              mountOptions = [
                "compress=zstd"
                "noatime"
              ];
            };

            subvolumes."/home" = {
              mountpoint = "/persist/home";
              mountOptions = [
                "compress=zstd"
                "relatime"
              ];
            };
          };
        };
      };
    };
  };

  fileSystems."/persist" = {
    neededForBoot = true;
  };
}
