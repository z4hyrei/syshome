{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;

    files = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];

    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/NetworkManager/system-connections"
    ];
  };

  programs.fuse.userAllowOther = true;

  boot.initrd.systemd.services.restore-rootfs = {
    description = "Rollback BTRFS `/` to the pristine state";

    wantedBy = [
      "initrd.target"
    ];
    requires = [
      "dev-mapper-cryptroot.device"
    ];
    before = [
      "sysroot.mount"
    ];
    after = [
      "systemd-cryptsetup@enc.service"
      "dev-mapper-cryptroot.device"
    ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";

    script = ''
      mkdir -p /tmp
      MNTPOINT=$(mktemp -d)
      (
        mount -t btrfs -o subvol=/ /dev/mapper/cryptroot "$MNTPOINT"
        trap 'umount "$MNTPOINT" && rm -rf "$MNTPOINT"' EXIT

        echo "Cleaning /rootfs subvolume"
        btrfs subvolume list -o "$MNTPOINT/rootfs" |
        cut -d ' ' -f 9 |
        sort |
        while read -r SUBVOLUME; do
          echo "Deleting /$SUBVOLUME subvolume"
          btrfs subvolume delete "$MNTPOINT/$SUBVOLUME"
        done &&
        (
          echo "Deleting /rootfs subvolume"
          btrfs subvolume delete "$MNTPOINT/rootfs"
        )

        echo "Restoring blank /rootfs subvolume"
        btrfs subvolume snapshot "$MNTPOINT/rootfs-blank" "$MNTPOINT/rootfs"
      )
    '';
  };

  system.activationScripts.persistent-dirs.text =
    let
      mkHomePersist =
        user:
        lib.optionalString user.createHome ''
          mkdir -p /persist/${user.home}
          chown ${user.name}:${user.group} /persist/${user.home}
          chmod ${user.homeMode} /persist/${user.home}
        '';
      users = lib.attrValues config.users.users;
    in
    lib.concatLines (map mkHomePersist users);
}
