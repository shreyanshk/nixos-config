# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }: {
	imports = [
		<nixpkgs/nixos/modules/installer/scan/not-detected.nix>
	];

	# i915: enable better power savings
	boot.extraModprobeConfig = ''
		options i915 enable_dc=1 enable_fbc=1 enable_rc6=1 semaphores=1 disable_power_well=0 enable_guc=3
	'';
	boot.extraModulePackages = [ ];
	boot.initrd.availableKernelModules = [
		"ahci"
		"rtsx_pci_sdmmc"
		"sd_mod"
		"sr_mod"
		"usb_storage"
		"xhci_pci"
	];
	boot.kernelModules = [ "kvm-intel" ];
	boot.kernelParams = [
		"acpi_backlight=native" # best backlight control method for my computer
		# https://github.com/Bumblebee-Project/Bumblebee/issues/764#issuecomment-234494238
		"acpi_osi=!" # to make Nvidia play nice with Linux
		"acpi_osi=\"Windows 2009\"" # to make Nvidia play nice with Linux
		"intel_pstate=skylake_hwp" # this enables Intel's SpeedShift
	];

	fileSystems."/" = {
		device = "/dev/disk/by-partlabel/NixOS";
		fsType = "btrfs";
		options = [ "compress=zlib" "discard" "noatime" "nodiratime" ];
	};
	fileSystems."/boot" = {
		device = "/dev/disk/by-partlabel/EFI";
		fsType = "vfat";
		options = [ "discard" "noatime" "nodiratime" ];
	};

	hardware.bluetooth = {
		enable = true;
		powerOnBoot = false;
	};
	hardware.bumblebee.enable = true;
	hardware.cpu.intel.updateMicrocode = true;

	nix.maxJobs = lib.mkDefault 8;
	powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

	swapDevices = [
		{ device = "/dev/disk/by-partlabel/Swap"; }
	];
}
