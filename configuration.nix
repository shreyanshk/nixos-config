# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
	imports = [ # Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true; # modify NVRAM

	boot.plymouth.enable = true; # nice boot splash screen

	boot.tmpOnTmpfs = true; # mount /tmp as tmpfs

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		# begin KDE 5 stuff
		ark # archiving tool
		gwenview # photo viewer
		k3b # disk burning tool
		kcalc # KDE calculator
		kdeconnect # e:firewall; remote control
		konversation # IRC client
		krita # graphics editor
		ktorrent # torrent client
		okular # document viewer
		spectacle # screenshot utility
		yakuake # drop down terminal
		# end KDE 5 stuff
		aria2 # better downloader
		bat # better 'cat'
		cryptsetup # work with encrypted volumes
		cudatoolkit # NVIDIA CUDA support software
		darkhttpd # fast HTTP 1.1 static server
		exfat # handle exfat filesystem
		fd # better 'find'
		file # recognize type of data contained in files
		gcc # compiler
		go # Golang compiler
		git # distributed version control system
		gnumake # build automation tool
		htop # better 'top'
		iw # manipulate WiFi adapters
		lsof # list open files
		mkpasswd # to generate hashes for passwords
		ncdu # disk utility program
		neovim # e:environment.variables.EDITOR; text editor
		ntfs3g # work with Window's NTFS filesystem
		powertop # measure computer's power consumption
		rustup # rust installer
		sshfs-fuse # access filesystem over SSH
		syncthing # e:firewall opensource P2P file sync
		tldr # simpler 'man'
		traceroute # trace path to node on network
		tree # recursive directory listing program
		unrar # read RAR files
		unzip # read ZIP files
		usbutils # tools for USB devices
	];

	environment.variables = {
		EDITOR = "nvim";
		PAGER = "less";
	};

	# font being replaced is in comment
	fonts.fonts = with pkgs; [
		caladea # Cambria
		carlito # Calibri
		hack-font
		liberation_ttf # Times New Roman, Arial, Courier New
		noto-fonts
		noto-fonts-emoji
	];

	# default pulseaudio doesn't support bluetooth; use full package
	hardware.pulseaudio = {
		enable = true;
		package = pkgs.pulseaudioFull;
	};

	networking.hostName = "invariant";
	networking.firewall.allowedTCPPorts = [
		22000 # Syncthing port
	];
	# networking.firewall.allowedUDPPorts = [ ... ];
	networking.firewall.allowedTCPPortRanges = [
		{ from = 1714; to = 1764; } # KDE Connect ports
	];
	networking.firewall.allowedUDPPortRanges = [
		{ from = 1714; to = 1764; } # KDE Connect ports
	];
	# disable the firewall altogether.
	# networking.firewall.enable = false;
	networking.networkmanager.enable = true;

	nix.buildCores = 0; # "make" on all cores during nixos compilations
	nixpkgs.config.allowUnfree = true; # proprietary drivers/firmware

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.bash.enableCompletion = true;
	# programs.mtr.enable = true;
	# programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
	programs.adb.enable = true; # e:user Groups; Android debugging, ADB
	programs.fish.enable = true; # e:users.defaultUserShell
	programs.wireshark.enable = true; # e:user Groups; packet analyzer.

	# List services that you want to enable
	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;
	# Enable CUPS to print documents.
	# services.printing.enable = true;
	# services.printing.drivers = [ pkgs.canon-cups-ufr2 ];

	services.fstrim.enable = true; # maintain SSD performance
	services.tlp = { # Power management for Linux
		enable = true;
		extraConfig = ''
			# disable sound card power management
			# fix pops when sound card switches state
			SOUND_POWER_SAVE_ON_AC=0
			SOUND_POWER_SAVE_ON_BAT=0
			# The governers are not set by default
			# https://github.com/NixOS/nixpkgs/issues/46048
			CPU_SCALING_GOVERNOR_ON_AC=performance
			CPU_SCALING_GOVERNOR_ON_BAT=powersave
		'';
	};
	services.thermald.enable = true; # maintain temperatures
	services.udev.extraRules = ''
		ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="noop"
	''; # set noop scheduler for SSDs

	# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.xserver.layout = "us";
	services.xserver.xkbOptions = "eurosign:e";

	# Enable the KDE Desktop Environment.
	services.xserver.desktopManager.plasma5.enable = true;
	services.xserver.displayManager.sddm = {
		autoNumlock = true;
		enable = true;
	};

	# Enable touchpad support.
	services.xserver.libinput.enable = true;
	services.xserver.multitouch.enable = true;

	time.timeZone = "Asia/Kolkata";

	users = {
		defaultUserShell = pkgs.fish;
		mutableUsers = false; # enable declarative user management
		extraUsers.shreyansh = {
			description = "Shreyansh Jain";
			extraGroups = [
				"adbusers" # enable Android Dev tools
				"audio" # control audio settings
				"docker" # access docker daemon
				"libvirtd" # access libvert for virt-manager
				"networkmanager" # configure network settings
				"wheel" # superuser/root access
				"wireshark" # for wireshark + packet capture
			];
			hashedPassword = "$6$KnTjypp3$Ysx5/4XmAVJeXbf7XupX5IgcJF/IinLpH7ivRzNKlH4kYlZDTH6olQTFHi0v54j/o.McK5JVqs580mGj7TSlI/";
			isNormalUser = true;
			uid = 1000;
		};
	};

	# enable virtualisation
	virtualisation.docker = { # deploy apps with containers
		enable = true;
		# liveRestore = false;
	};
	virtualisation.libvirtd.enable = true;

	# This value determines the NixOS release with which your system is to be
	# compatible, in order to avoid breaking some software such as database
	# servers. You should change this only after NixOS release notes say you
	# should.
	system.stateVersion = "18.03"; # Did you read the comment?
}
