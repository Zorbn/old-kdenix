{ config, pkgs, callPackage, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support.

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s20f0u9u4u2.useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  environment.sessionVariables = rec {
    __GL_SYNC_DISPLAY_DEVICE = "DP-0"; # Set this to highest refresh rate monitor
    KWIN_X11_REFRESH_RATE = "144000";
    KWIN_X11_NO_SYNC_TO_VBLANK = "1";
    KWIN_X11_FORCE_SOFTWARE_VSYNC = "1";
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Enable the Desktop Environment.
  services.xserver = {
    enable = true;

    screenSection = ''
      Option         "Stereo" "0"
      Option         "nvidiaXineramaInfoOrder" "DFP-2"
      Option         "metamodes" "DP-0: 1920x1080_144 +1920+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, DVI-D-0: nvidia-auto-select +3840+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, HDMI-0: nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    '';

    deviceSection = ''
      Option         "NoFlip" "true"
    '';

    videoDrivers = [ "nvidia" ];
    layout = "us";

    libinput = {
      enable = true;
      
      mouse = {
        accelProfile = "flat";
      };

      touchpad = {
        accelProfile = "flat";
      };
    };

    desktopManager = {
      plasma5.enable = true;
    };

    displayManager.sddm.enable = true;
    displayManager.defaultSession = "plasma";
  };

  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ???passwd???.
  users.users.nic = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ???sudo??? for the user.
  };

  nixpkgs.config.allowUnfree = true;

  # Enable grub, useful for dualboot
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    version = 2;
    device = "nodev";
    useOSProber = true;
    gfxmodeEfi = "1920x1080";
  };

  services.emacs.package = pkgs.emacsUnstable;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    wget
    firefox
    multimc
    jdk8
    logmein-hamachi
    emacsGit
    git
  ];

  programs.steam.enable = true;

  # Gaming with hamachi
  services.logmein-hamachi.enable = true;

  # Enable flatpak incase nix repos don't have something
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It???s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

}

