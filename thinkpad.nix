# $ man configuration.nix
# $ nixos-help
# https://search.nixos.org/packages

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz";
  nur = builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz";
in
{
  imports =
    [
      # include the results of the hardware scan
      /etc/nixos/hardware-configuration.nix

      # install home-manager
      (import "${home-manager}/nixos")
    ];

  # install nur (nix user packages)
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import nur {
      inherit pkgs;
    };
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;
  # networking.wireless.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 8080 ];

  time.timeZone = "Europe/Zagreb";
  i18n.defaultLocale = "en_US.utf8";

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.layout = "us";

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

  services.printing.enable = true;
  services.openssh.enable = true;

  # sudo disable passport prompt for wheel group
  security.sudo.wheelNeedsPassword = false;

  users.users.bd = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users.bd = {
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
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

    programs.firefox = {
      enable = true;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
      ];
      profiles.default ={
        id = 0;
        settings = {
          "app.update.auto" = false;
          "signon.rememberSignons" = false;
          "identity.fxaccounts.account.device.name" = config.networking.hostName;
        };
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # cli
    curl
    vim
    tmux
    tree
    wget

    # gui
    firefox
  ];

  # recommended to leave this value at the release version of the first install
  system.stateVersion = "22.05";
}
