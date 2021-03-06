{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ../personal.nix ];

  networking.hostName = "xps";

  modules = {
    desktop.sway = {
      enable = true;
      fancy = true;
    };
    browsers = {
      default = "firefox";
      firefox.enable = true;
    };
    media = {
      daw.enable = true;
      documents.enable = true;
      graphics.enable = true;
      recording.enable = true;
      spotify.enable = true;
    };
    term = {
      default = "alacritty";
      alacritty.enable = true;
    };
    media = {
      mpv.enable = true;
      ncmpcpp.enable = true;
    };
    messengers = {
      rss.enable = true;
      matrix.enable = true;
      signal.enable = true;
      email.enable = true;
      weechat.enable = true;
    };
    editors = {
      default = "nvim";
      emacs = {
        enable = true;
        daemon = true;
      };
      vim.enable = true;
      vscode.enable = true;
    };
    dev = {
      node.enable = true;
      cc.enable = true;
      rust.enable = true;
    };
    hardware = {
      remarkable.enable = true;
      extraHosts = {
        enable = true;
        allowSocial = true;
      };
      audio.enable = true;
      bluetooth.enable = true;
      scanner.enable = true;
      printer.enable = true;
      fs = {
        enable = true;
        ssd.enable = true;
      };
    };
    shell = {
      git.enable = true;
      gnupg = {
        enable = true;
        gui = true;
        cacheTTL = 60480000;
      };
      direnv = {
        enable = true;
        preventGC = true;
      };
      lf.enable = true;
      zsh.enable = true;
    };
    services = {
      syncthing.enable = true;
      ssh.enable = true;
      backup.enable = true;
      dnsmasq.enable = true;
    };
    theme.active = "nordic";
  };

  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;
  services.getty.autologinUser = "jake";

  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false; # wifi beast mode
      };
    };
  };

  users.users.jake.extraGroups = [ "networkmanager" ];

  services.fwupd.enable = true;
  services.xserver.libinput.enable = true;
}
