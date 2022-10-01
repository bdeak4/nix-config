# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nixos-hardware = builtins.fetchTarball "https://github.com/NixOS/nixos-hardware/archive/master.tar.gz";
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      (import "${nixos-hardware}/lenovo/thinkpad/t14/amd/gen3")
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  #boot.extraModulePackages = [ config.boot.kernelPackages.r8168 ];
  #boot.blacklistedKernelModules = [ "r8169" ];
  hardware.enableAllFirmware = true;

  # Enable energy savings during sleep
  boot.kernelParams = ["mem_sleep_default=deep"];

  networking.hostName = "workpc";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zagreb";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "hr";
    xkbVariant = "us";
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

  services.fwupd.enable = true;

  # sudo disable passport prompt for wheel group
  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bd = {
    isNormalUser = true;
    description = "bd";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
  };

  home-manager.users.bd = {
    programs.bash = {
      enable = true;
      sessionVariables = {
        EDITOR = "vim";
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
      extraConfig = ''
        au FileType markdown setl ts=2 sw=2 et
      '';
    };

    programs.git = {
      enable = true;
      userName = "Bartol Deak";
      userEmail = "b@bdeak.net";
      signing = {
        signByDefault = true;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuAQ43SM0EVulTuivIuAGI0P2RcREUY0nTRtlolZDZ b@bdeak.net";
      };
      extraConfig = {
        gpg = {
          format = "ssh";
        };
        commit = {
          verbose = true;
        };
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        monospace-font-name = "JetBrains Mono, 10";
      };
      "org/gnome/desktop/background" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-l.svg";
        picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/blobs-d.svg";
        primary-color = "#3465a4";
        secondary-color = "#000000";
      };
      "org/gnome/desktop/sound".event-sounds = false; # disable terminal bell
      "org/gnome/shell".favorite-apps = [ ];
      "org/gnome/settings-daemon/plugins/power" = {
        idle-dim = false;
        power-button-action = "suspend";
        sleep-inactive-ac-type = "nothing";
      };
    };
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [ jetbrains-mono ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.allowBroken = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git vim tmux curl wget tree
    ripgrep jq pup pdfgrep
    powertop
    pandoc
    rclone restic
    wl-clipboard
    nixpkgs-fmt
    zbar
    qrencode
    htop ncdu
    duf
    esh entr
    mailcatcher
    bitwarden-cli
    azure-cli azure-storage-azcopy

    elixir
    nodejs yarn
    dotnet-sdk
    python38
    gcc
    terraform

    firefox-wayland
    thunderbird-wayland
    slack
    vscode
    vlc
    jetbrains.rider
    transmission-gtk
    gparted

    linuxPackages_xanmod.r8168
  ];

  # exclude useless gnome apps
  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-text-editor
  ]) ++ (with pkgs.gnome; [
    cheese # webcam tool
    gedit # text editor
    epiphany # web browser
    geary # email reader
    gnome-characters
    gnome-contacts
    gnome-maps
    gnome-calculator
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
  ]);

  powerManagement.powertop.enable = true;
  virtualisation.docker.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  #services.fprintd.enable = true;


  networking.wg-quick.interfaces = {
    dump_ured = {
      address = [ "192.168.44.2/24" ];
      privateKeyFile = "/home/bd/.wg-privatekey";

      peers = [
        {
          publicKey = "oaC/dmc7c9Qd6c1/ZhjOWZo7rvVSIE9cDRnecl7mon4=";
          allowedIPs = [ "192.168.88.0/24" ];
          endpoint = "193.198.39.246:51820";
        }
      ];
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
