{ config, pkgs, ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "thinkpad-home";
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
  };

  # sudo disable passport prompt for wheel group
  security.sudo.wheelNeedsPassword = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bd = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker" ];

    packages = with pkgs; [
    ];
  };

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [ jetbrains-mono ];
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
    nixpkgs-fmt
    htop
    ncdu
    duf
    tcpdump
    pandoc
    nodejs
    python38
    gcc
    ghostscript
    mailcatcher

    # gui
    firefox-wayland
    thunderbird-102-wayland
    slack
    vscode
    vlc
    jetbrains.rider
    gimp
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

  # List services that you want to enable:

  services.openssh.enable = true;
  services.avahi.enable = true;

  virtualisation.docker.enable = true;

  networking.wg-quick.interfaces = {
    dump_ured = {
      address = [ "192.168.44.2/24" ];
      privateKeyFile = "/home/bd/.wg-privatekey";

      peers = [
        {
          publicKey = "oaC/dmc7c9Qd6c1/ZhjOWZo7rvVSIE9cDRnecl7mon4=";
          allowedIPs = [ "192.168.88.0/24" ];
          endpoint = "193.198.39.246:51820";
          #persistentKeepalive = 25;
        }
      ];
    };
  };

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
