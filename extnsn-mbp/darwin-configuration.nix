{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users.users.eedev = {
    name = "eedev";
    home = "/Users/eedev";
  };
  home-manager.users.eedev = { pkgs, ... }: {
    home.packages = with pkgs; [ neofetch ];
    #programs.bash.enable = true;
  };

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    vim
    mpv
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
