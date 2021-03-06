############################################################################## NIX OS 
##############################################################################
{ config, pkgs, ... }:
{
 imports = [./hardware-configuration.nix];
 ####################################################################################################################################################################
 # Packages
 nixpkgs.config = {
 	allowUnfree = true;
 };
environment.systemPackages = with pkgs; [

	# Apperence
	arc-theme
	arc-icon-theme
	gnome3.gnome_themes_standard
	gtk_engines
	gtk-engine-murrine
	haskellPackages.xmobar
	haskellPackages.xmonad
	tango-icon-theme
	rofi
	trayer
	xorg.xrandr

  # Software
	beancount
	calibre
	colordiff
	dwarf-fortress
	dwarf-fortress-packages.phoebus-theme
	fava
	gparted
	htop
	i3lock
	keepass
	less
	libreoffice
	lxappearance
	neovim
	openvpn
	pavucontrol
	pcmanfm
	roxterm
	screenfetch
	seafile-client
	shutter
	ssvnc
	steam
	taskwarrior
	thunderbird
	tig
	tldr
	x11vnc
	zathura  # PDF Viewer

	# System
	arandr
	bashmount
	busybox
	curl
	davfs2
	exfat
	fam
	ghc
	git
	gxmessage
	jdk
	jre
	shared_mime_info
	lxmenu-data
	networkmanagerapplet
	ntfs3g
	numlockx
	pasystray
	pciutils
	python
	python27Packages.pip
	python27Packages.setuptools
	python3
	python35Packages.pip
	python35Packages.setuptools
	unrar
	unzip
	xbrightness
	xdotool
	xorg.libXt
	xorg.libXtst

  # Writing
	aspell
	aspellDicts.de
	aspellDicts.en
	# texlive.combined.scheme-full
];


 ####################################################################################################################################################################
 # Services

 services.xserver = {
         # Graphic
	 videoDrivers = [ "intel nvidia" ];

	 # keyboard
         enable = true;
         layout = "us";
	 xkbOptions = "eurosign:e";

   # Notebook
	 synaptics.enable = true;
	 synaptics.twoFingerScroll = true;

   # UI
	 #windowManager.xmonad.enable = true;
         #windowManager.default = "xmonad";
         #windowManager.xmonad.enableContribAndExtras = true;
         #desktopManager.xterm.enable = false;
	 windowManager.bspwm.enable = true;
         windowManager.default = "bspwm";
         windowManager.bspwm.configFile = "/home/user/.dotfiles/bspwm/bspwmrc";
         windowManager.bspwm.sxhkd.configFile= "/home/user/.dotfiles/bspwm/sxhkdrc";
         desktopManager.xterm.enable = false;

   displayManager.auto = {
	 	enable = true;
		user = "user";
	 };


	 # Multiple monitor
	 # xrandrHeads = [ "HDMI-0" "DVI-I-1" ];
 };

services.gnome3.gvfs.enable = true;
services.openssh.forwardX11 = true;
 #services.teamviewer.enable  = true;

 ####################################################################################################################################################################
 # Gerneral config

 	 # Kernel
	 # boot.kernelPackages = pkgs.linuxPackages_latest; #_4_9; #_latest;

   	# System Language
	 i18n = {
        	defaultLocale = "en_US.UTF-8";
	 };

	 # Time
  	 time.timeZone = "Europe/Berlin";

	 # Mount
	 # fileSystems."/oyra" =
	 # {
	 # device = "https://cloud.test.eu/seafdav";
   	 # options = ["noauto,users,rw"];
	 # fsType = "davfs";
	 # };
	 security.sudo.extraConfig =
	 ''
  	 user ALL=(ALL) NOPASSWD: /home/user/.dotfiles/script/webdav.sh
	 '';


	 # Fonts
	 fonts = {
		enableFontDir = true;
		enableGhostscriptFonts = true;
	 	fontconfig.ultimate.enable = true;
		fonts = with pkgs; [
	     	siji		
		#	nerdfonts
	     	# 	inconsolata
	     	# 	terminus_font
	     	# 	proggyfonts
	     	#	dejavu_fonts
	     	# 	font-awesome-ttf
	     	# 	ubuntu_font_family
	     	# 	source-code-pro
	     	# 	source-sans-pro
	     	# 	source-serif-pro
	    	];
	  };

	 # Redshift
	 services.redshift = {
	     enable = true;
	     latitude = "50";
	     longitude = "10";
	 };

	 # Network
   	 networking.networkmanager.enable = true;

	 # Hardware
	 hardware = {
	     bumblebee = {
	     	enable = true;
	        connectDisplay = true;
	     	driver = "nvidia";
	     };

	     pulseaudio = {
   	 	enable = true;
		support32Bit = true;
	     };

	     opengl.driSupport32Bit = true;
	 };

	 # Printer
  	 services.printing = {
   	     enable = true;
	     drivers = [ pkgs.samsungUnifiedLinuxDriver ];
  	 };

         # ZSH
         programs.zsh = {
	 	enable = true;
		interactiveShellInit = ''
      			export EDITOR=nvim
			# Java
      		 	export _JAVA_AWT_WM_NONREPARENTING=1
      		'';

		shellAliases = {
				ls="ls --color=auto";
				l="ls -alh";
	    			grep="grep -i --color=auto";
	    		};
		 };
         users.defaultUserShell = "/run/current-system/sw/bin/zsh";
	
	 # light
	 programs.light.enable = true;

         # SSH
         services.openssh.enable = true;

	 # SWAP
	 swapDevices = [{
		 device = "/var/cache/swap/swap0";
	 }];
	 #swapDevices.*.size = "1024";
	
	 # Clean up
	 nix.gc.automatic = true;
	 nix.gc.dates = "16:14";
	 nix.gc.options = "--delete-older-than 30d";
	 nix.extraOptions = ''
	 gc-keep-output = true
	 gc-keep-derivations = true
	 auto-optimise-stor = true
	 '';
	
	 # boot.cleanTmpDir = true;
	
	 # Search
	 services.locate.enable = true;
	 services.locate.interval = "10 * * * *";

 ####################################################################################################################################################################
 # Users

 # user
 users.extraUsers.user = {
         isNormalUser = true;
         home = "/home/user";
         extraGroups = ["davfs2""wheel" "networkmanager" "vboxusers"];
 };

 ####################################################################################################################################################################
 # Channel
 # system.autoUpgrade.channel = "https://nixos.org/channels/nixos-unstable";
 # Channel List https://nixos.org/channels/
 # Config Version
 system.stateVersion = "17.03";

 ####################################################################################################################################################################
 # Bootloader
 boot.loader.systemd-boot.enable = true;
 boot.loader.efi.canTouchEfiVariables = true;

####################################################################################################################################################################
 # Virtualisation
 #virtualisation.libvirtd.enable = true;
 #virtualisation.libvirtd.enableKVM = true;
 boot.kernelModules = [ "kvm-intel" "tun" "virtio" ];
 virtualisation.virtualbox.host.enable = true;
 }
