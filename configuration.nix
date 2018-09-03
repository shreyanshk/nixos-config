# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
	# Python with packages
	myPyPkgs = python-packages: with python-packages; [
		ipython
		jupyter
	];
	py3WithPkgs = pkgs.python3.withPackages myPyPkgs;
	# RStudio with packages
	RStudioWithPkgs = with pkgs; rstudioWrapper.override {
		packages = with rPackages; [
			ggplot2
		];
	};
in {
	imports =
	[ # Include the results of the hardware scan.
		./hardware-configuration.nix
	];

	boot.tmpOnTmpfs = true; # mount /tmp as tmpfs

	# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "invariantNix";
	networking.networkmanager.enable = true;

	# Select internationalisation properties.
	# i18n = {
	#   consoleFont = "Lat2-Terminus16";
	#   consoleKeyMap = "us";
	#   defaultLocale = "en_US.UTF-8";
	# };

	time.timeZone = "Asia/Kolkata";

	nixpkgs.config.allowUnfree = true;
	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		# begin KDE 5 stuff
		ark # archiving tool
		gwenview # photo viewer
		k3b # disk burning tool
		kcalc
		kdeconnect
		ktorrent # torrent client
		okular # document viewer
		spectacle # screenshot utility
		yakuake # drop down terminal
		# end KDE 5 stuff
		beets
		file # program for recognizing the type of data contained in a file
		firefox # browser
		gcc # compiler
		git
		go
		hexchat # IRC client
		iw
		libreoffice
		mkpasswd
		neovim # e:environment.variables.EDITOR; text editor
		neovim-qt # Qt GUI for neovim
		ntfs3g # work with Window's NTFS filesystem
		py3WithPkgs
		RStudioWithPkgs
		qsyncthingtray
		tdesktop # telegram client
		vlc # media player
	];

	environment.variables = { EDITOR = "nvim"; };

	# enable virtualisation
	virtualisation.docker.enable = true;
	virtualisation.virtualbox.host.enable = true;
	nixpkgs.config.virtualbox.enableExtensionPack = true;

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.bash.enableCompletion = true;
	# programs.mtr.enable = true;
	# programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true;

	# Open ports in the firewall.
	# networking.firewall.allowedTCPPorts = [ ... ];
	# networking.firewall.allowedUDPPorts = [ ... ];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# Enable CUPS to print documents.
	# services.printing.enable = true;

	services.fstrim.enable = true;
	# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.xserver.layout = "us";
	services.xserver.xkbOptions = "eurosign:e";

	# Enable touchpad support.
	services.xserver.libinput.enable = true;

	# Enable the KDE Desktop Environment.
	services.xserver.displayManager.sddm.enable = true;
	services.xserver.desktopManager.plasma5.enable = true;

	users = {
		defaultUserShell = pkgs.zsh;
		mutableUsers = false;
		extraUsers.shreyansh = {
			description = "Shreyansh Jain";
			extraGroups = [ "audio" "docker" "networkmanager" "vboxusers" "wheel" ];
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
