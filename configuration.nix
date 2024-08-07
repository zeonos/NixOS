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
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  networking.wireless = {
    enable = true;
    networks."ducas".psk = "5555555555";
    extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
    # output ends up in /run/wpa_supplicant/wpa_supplicant.conf
  };

  # Enable networking
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";

  # Select internationalisation properties.
  i18n.defaultLocale = "da_DK.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "da_DK.UTF-8";
    LC_IDENTIFICATION = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_NAME = "da_DK.UTF-8";
    LC_NUMERIC = "da_DK.UTF-8";
    LC_PAPER = "da_DK.UTF-8";
    LC_TELEPHONE = "da_DK.UTF-8";
    LC_TIME = "da_DK.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "dk";
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure console keymap
  console.keyMap = "dk-latin1";

# Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dekra = {
    isNormalUser = true;
    description = "DEKRA Bilsyn";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "dekra";

  #Permitted insecure packages
  nixpkgs.config.permittedInsecurePackages = [
                "adobe-reader-9.5.5"
              ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    adobe-reader
    google-chrome
    chromium
    flameshot
    ffmpeg
    git
    libreoffice
    wget
    pavucontrol
    shotcut
    simplescreenrecorder
    system-config-printer
    vlc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Extra chrome policies
  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    ];
    extraOpts = {
    "BrowserSignin" = 0;
    "BookmarkBarEnabled" = true;
    "SyncDisabled" = true;
    "HomepageIsNewTabPage" = true;
    "PasswordManagerEnabled" = false;
    "RestoreOnStartupURLs" = "https://bilsyn.dekra.nu";
    "HomepageLocation" = "https://bilsyn.dekra.nu";
    "SpellcheckEnabled" = true;
    "SpellcheckLanguage" = [
                             "da-DK"
                           ];
      "ManagedBookmarks" = [
    {
        "toplevel_name" = "Bookmarks bar";
    }
    {
        "name" = "Forside";
        "url" = "bilsyn.dekra.nu";
    }
    {
        "name" = "Google";
        "url" = "google.com";
    }
    {
        "name" = "Youtube";
        "url" = "youtube.com";
    }
    {
        "children" = [
        {
            "name" = "DEKRA Dokumentportal";
            "url" = "https://dekracloud.sharepoint.com/sites/DEKRADKBilsynSP/Dokumentportal/Forms/AllItems.aspx";
        }
        {
            "name" = "Kvalitetssystem";
            "url" = "https://bilsyn.dekra.nu/kvalitet";
        }
        {
            "name" = "Fælles Forum";
            "url" = "https://dekracloud.sharepoint.com/sites/DEKRADKBilsynSP/Flles%20Forum";
        }
        {
            "name" = "Batteritest";
            "url" = "https://battery-soh.dekra.com/#/";
        }
        {
            "name" = "Pava Portal";
            "url" = "https://partner.pava.dk/Login?validating=1&orgpageid=385";
        }
        ];
        "name" = "DEKRA";
    }
    {
        "children" = [
        {
            "name" = "Fstyr.dk";
            "url" = "https://dekracloud.sharepoint.com/sites/DEKRADKBilsynSP/Dokumentportal/Forms/AllItems.aspx";
        }
        {
            "name" = "Vejl. Syn af køretøjer Jan 2021";
            "url" = "https://bilsyn.dekra.nu/kvalitet";
        }
        {
            "name" = "Synsguide (PDF)";
            "url" = "https://dekracloud.sharepoint.com/sites/DEKRADKBilsynSP/Flles%20Forum";
        }
        {
            "name" = " Dokumentportal";
            "url" = "https://battery-soh.dekra.com/#/";
        }
        ];
        "name" = "Færdselsstyrelsen";
    }
    ];
    };
  };

  # Stop system from sleeping
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;



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
  system.stateVersion = "00.01"; # Did you read the comment?

}

