===========================
NixOS config of my computer
===========================

Tested with NixOS 18.09

How to install?
---------------

You need to setup partitions before you can setup this and these partitions are defined in the hardware-configuration.nix file in the repository. To install this configuration you need:

1. "NixOS" labeled `BTRFS`_ partition where the operating system will be installed.
2. "EFI" labeled `EFI partition`_ with boot flag where the bootloader will be installed.
3. "Swap" labeled partition which will be used as `Linux swap`_.

.. _BTRFS: https://btrfs.wiki.kernel.org/index.php/Main_Page
.. _EFI partition: https://wiki.archlinux.org/index.php/EFI_system_partition
.. _Linux swap: https://wiki.archlinux.org/index.php/Swap

Please ensure that you have a working internet connection as this step will download a lot of data. You need to download the `NixOS installer`_, boot with it and mount the partitions to install base system:

.. code-block:: console

    # mount /dev/disk/by-partlabel/NixOS /mnt
    # mkdir /mnt/boot
    # mount /dev/disk/by-partlabel/EFI /mnt/boot
    # mkdir -p /mnt/etc/nixos
    # cp <config path> /mnt/etc/nixos/
    # nixos-install   # installs the base system

.. _NixOS installer: https://nixos.org/nixos/download.html

This will set you up with a bootable system and once it's finished, you will reboot into a configuration that matches what I'm running on my computer.

Notes to self
-------------

1. **(in comments) e: <var>**
        | Commented expr affects expr "var" in some way and this comment is used to mark relationship between them if they are defined at distant places.
        | This is to make sure that I remember to update downstream expr if I update this expr.
        | For example: environment.variables.EDITOR (= "nvim") depends on neovim being installed but they are defined at different places.
