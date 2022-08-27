# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix

      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zagreb";
  i18n.defaultLocale = "en_US.utf8";

  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    layout = "us";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  # sudo disable passport prompt for wheel group
  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bd = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];

    packages = with pkgs; [
    ];
  };

  home-manager.users.bd = {
    dconf.settings = {
      "org/gnome/shell".favorite-apps = [];
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
      "org/gnome/desktop/background" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
        primary-color = "#3465a4";
        secondary-color = "#000000";
      };
    };

    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];
      settings = {
        ignorecase = true;
      };
    };

    programs.git = {
      enable = true;
      userName  = "Bartol Deak";
      userEmail = "b@bdeak.net";
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # cli
    vim
    git
    tmux
    curl
    wget
    tree
    wl-clipboard

    # gui
    firefox
    slack
  ];

  # List services that you want to enable:

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
