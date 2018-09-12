# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: {
	imports = [ # Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	boot.tmpOnTmpfs = true; # mount /tmp as tmpfs

	# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# nice boot splash screen
	boot.plymouth.enable = true;

	networking.hostName = "invariantNix";
	networking.networkmanager.enable = true;

	# Select internationalisation properties.
	# i18n = {
	#   consoleFont = "Lat2-Terminus16";
	#   consoleKeyMap = "us";
	#   defaultLocale = "en_US.UTF-8";
	# };

	time.timeZone = "Asia/Kolkata";

	nix.buildCores = 0; # run "make" on all available cores during nixos compilations
	nixpkgs.config.allowUnfree = true;
	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		# begin KDE 5 stuff
		ark # archiving tool
		gwenview # photo viewer
		k3b # disk burning tool
		kcalc # KDE calculator
		kdeconnect # e: networking.firewall; KDE project to communicate across devices
		ktorrent # torrent client
		okular # document viewer
		spectacle # screenshot utility
		yakuake # drop down terminal
		# end KDE 5 stuff
		file # program for recognizing the type of data contained in a file
		gcc # compiler
		git # distributed version control system
		iw # manipulate WiFi adapters
		mkpasswd # to generate hashes for passwords
		neovim # e:environment.variables.EDITOR; text editor
		ncdu # disk utility program
		ntfs3g # work with Window's NTFS filesystem
		powertop # measure computer's power consumption
		tree # recursive directory listing program
		unzip # to handle ZIP files
	];

	environment.variables = {
		EDITOR = "nvim";
		PAGER = "less";
	};

	# enable virtualisation
	virtualisation.docker.enable = true;
	virtualisation.virtualbox.host.enable = true;
	nixpkgs.config.virtualbox.enableExtensionPack = true;

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.bash.enableCompletion = true;
	# programs.mtr.enable = true;
	# programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
	programs.fish.enable = true; # e: users.defaultUserShell
	programs.wireshark.enable = true; # e: users.extraUsers.<name>.extraGroups; wireshark is a packet analyzer.
	# programs.zsh.enable = true; # e: users.defaultUserShell

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	networking.firewall.allowedTCPPortRanges = [
		{ from = 1714; to = 1764; } # KDE Connect ports
	];
	networking.firewall.allowedUDPPortRanges = [
		{ from = 1714; to = 1764; } # KDE Connect ports
	];
	# disable the firewall altogether.
	# networking.firewall.enable = false;

	# Enable CUPS to print documents.
	# services.printing.enable = true;

	services.fstrim.enable = true; # discard unused blocks on SSD, maintain performance
	services.tlp = { # Power management for Linux
		enable = true;
		extraConfig = ''
			# disable sound card power management
			# causes annoying pops everytime sound card switches state
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

	# Enable touchpad support.
	services.xserver.libinput.enable = true;
	services.xserver.multitouch.enable = true;

	# Enable the KDE Desktop Environment.
	services.xserver.displayManager.sddm = {
		enable = true;
		extraConfig = ''
			[General]
			InputMethod=
		''; # disable virtual keyboard
	};
	services.xserver.desktopManager.plasma5.enable = true;

	users = {
		defaultUserShell = pkgs.fish;
		mutableUsers = false;
		extraUsers.shreyansh = {
			description = "Shreyansh Jain";
			extraGroups = [ "audio" "docker" "networkmanager" "vboxusers" "wireshark" "wheel" ];
			hashedPassword = "$6$KnTjypp3$Ysx5/4XmAVJeXbf7XupX5IgcJF/IinLpH7ivRzNKlH4kYlZDTH6olQTFHi0v54j/o.McK5JVqs580mGj7TSlI/";
			isNormalUser = true;
			uid = 1000;
		};
	};
	# This value determines the NixOS release with which your system is to be
	# compatible, in order to avoid breaking some software such as database
	# servers. You should change this only after NixOS release notes say you
	# should.
	system.stateVersion = "18.03"; # Did you read the comment?
}
