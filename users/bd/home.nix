{ config, pkgs, ... }:
{
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
    "org/gnome/desktop/input-sources" = {
      sources = "[('xkb', 'hr+us')]";
    };
    "org/gnome/desktop/sound".event-sounds = false; # disable terminal bell
    "org/gnome/shell".favorite-apps = [ ];
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      power-button-action = "nothing";
      sleep-inactive-ac-type = "nothing";
    };
  };
}
