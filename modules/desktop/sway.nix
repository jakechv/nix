{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.sway;
in {
  options.modules.desktop.sway = { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    programs.sway = {
      enable = true;
      extraPackages = with pkgs; [
        swaylock
        swayidle
        xwayland
        waybar
        mako
        kanshi
        wl-clipboard
        alacritty
        dmenu
      ];
      wrapperFeatures.gtk = true;
    };
    # Here we but a shell script into path, which lets us start sway.service (after importing the environment of the login shell).
    environment.systemPackages = with pkgs;
      [
        (pkgs.writeTextFile {
          name = "startsway";
          destination = "/bin/startsway";
          executable = true;
          text = ''
            #! ${pkgs.bash}/bin/bash

            # first import environment variables from the login manager
            systemctl --user import-environment
            # then start the service
            exec systemctl --user start sway.service
          '';
        })
      ];
    systemd.user.targets.sway-session = {
      description = "Sway compositor session";
      documentation = [ "man:systemd.special(7)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
    };

    systemd.user.services.sway = {
      description = "Sway - Wayland window manager";
      documentation = [ "man:sway(5)" ];
      bindsTo = [ "graphical-session.target" ];
      wants = [ "graphical-session-pre.target" ];
      after = [ "graphical-session-pre.target" ];
      # We explicitly unset PATH here, as we want it to be set by
      # systemctl --user import-environment in startsway
      environment.PATH = lib.mkForce null;
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.dbus}/bin/dbus-run-session ${pkgs.sway}/bin/sway --debug
        '';
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    services.redshift = {
      enable = true;
      # Redshift with wayland support isn't present in nixos-19.09 atm. You have to cherry-pick the commit from https://github.com/NixOS/nixpkgs/pull/68285 to do that.
      package = pkgs.redshift-wlr;
    };

    programs.waybar.enable = true;

    systemd.user.services.kanshi = {
      description = "Kanshi output autoconfig ";
      wantedBy = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      serviceConfig = {
        # kanshi doesn't have an option to specify config file yet, so it looks
        # at .config/kanshi/config
        ExecStart = ''
          ${pkgs.kanshi}/bin/kanshi
        '';
      };
      # RestartSec = 5;
      # Restart = "always";
    };
  };
}
