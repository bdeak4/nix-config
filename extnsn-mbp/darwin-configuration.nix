{ config, pkgs, ... }:
{
  imports = [
    (import "${builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-22.05.tar.gz}/nix-darwin")
  ];

  nix = {
    extraOptions = "experimental-features = nix-command flakes";
    package = pkgs.nixFlakes;
  };

  users.users.eedev = {
    home = "/Users/eedev"; # ???
  };
  home-manager.useGlobalPkgs = true;
  home-manager.users.eedev = {
    #programs.zsh = {
    #  enable = true;
    #  defaultKeymap = "emacs";
    #  sessionVariables = {
    #    EDITOR = "vim";
    #    PATH = "$PATH:/run/current-system/sw/bin"; # ???
    #  };
    #};

    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
      ];
    };
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    ripgrep
    neofetch
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  #environment.darwinConfig = "$HOME/src/nix-config/extnsn-mbp/configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
