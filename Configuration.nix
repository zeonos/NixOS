# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda1";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "Aarup1"; # Define your hostname.
  # networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "da_DK.utf8";

  # Configure keymap in X11
  services.xserver = {
    layout = "da";
    xkbVariant = "";
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  #Printer
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip pkgs.hplipWithPlugin pkgs.samsung-unified-linux-driver pkgs.splix ];

  #Scanner
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  #GVFS
  services.gvfs.enable = true;
  
  #Fish
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  #Pipewire
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
  # If you want to use JACK applications, uncomment this
  #jack.enable = true;
  };

  #Bluetooth
  hardware.bluetooth.enable = true;

  #Virtualisation
  #virtualisation.libvirtd.enable = true;
  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  #Flatpak
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.enable = true;

  #Picom
  services.picom.enable = true;
  services.picom.fade = true;
  services.picom.activeOpacity = 0.9;
  services.picom.inactiveOpacity = 0.7;
  services.picom.menuOpacity = 0.9;
  services.picom.opacityRules = [
                     "100:class_g = 'mpv'"
                     "100:class_g = 'librewolf'"
                     "100:class_g = 'Virt-manager'"
                     "100:class_g = 'pyrogenesis'"
                     "100:class_g = 'kdenlive'"
                     "100:class_g = '0ad'"
                     "100:class_g = 'Gimp'"
                     "100:class_g = 'qutebrowser'"
                     "100:class_g = 'vlc'"
                     "100:class_g = 'Brave-browser'"
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dekra = {
    isNormalUser = true;
    description = "dekra";
    extraGroups = [ "libvirtd" "networkmanager" "wheel" "scanner" "lp" "audio" ];
    packages = with pkgs; [];
  };

  #Permitted insecure packages
  nixpkgs.config.permittedInsecurePackages = [
                "electron-12.2.3"
                "adobe-reader-9.5.5"
              ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    adobe-reader
    dmenu
    emacs
    feh
    firefox
    google-chrome
    flameshot
    ffmpeg
    git
    gnome.simple-scan
    htop
    hydra-check
    kotatogram-desktop
    libreoffice
    librewolf
    lxappearance
    lxde.lxmenu-data
    lxde.lxsession
    maim
    meld
    mpv
    nomacs
    pavucontrol
    ranger
    ripgrep
    rofi
    tenacity
    tty-clock
    scrot
    shared-mime-info
    shotcut
    simplescreenrecorder
    sxiv
    system-config-printer
    vimix-gtk-themes
    vimix-icon-theme
    vlc
    volctl
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # aist services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
