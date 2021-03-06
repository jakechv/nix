{ config, lib, pkgs, ... }:
# lock for wayland

with lib;
with lib.my;
let
  colors = config.modules.theme.color;
  cfg = config.modules.wayland.swaylock;
  lock = (pkgs.writeScriptBin "lock" ''
    #!${pkgs.stdenv.shell}
    exec ${pkgs.swaylock-effects}/bin/swaylock
  '');
in {
  options.modules.wayland.swaylock = { enable = mkBoolOpt false; };
  # systemd.user.services.swayidle = mkIf cfg.fancy {
  #   # enable = true;
  #   description = "Idle Manager for Wayland";
  #   documentation = [ "man:swayidle(1)" ];
  #   wantedBy = [ "sway-session.target" ];
  #   partOf = [ "graphical-session.target" ];
  #   serviceConfig = {
  #     ExecStart = ''
  #       ${pkgs.swayidle}/bin/swayidle -w -d \
  #                timeout 5 '${lock}/bin/lock && ${pkgs.sway}/bin/swaymsg "output * dpms off"' \
  #                resume '${pkgs.sway}/bin/swaymsg "output * dpms on"'
  #              '';
  #   };
  # };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ lock swayidle ];
    home.configFile = {
      "swaylock/config".text = (with colors; ''
        line-color=${colors.background}
        inside-color=${colors.background}
        ring-color=${background}
        separator-color=${colors.foreground}
        key-hl-color=${colors.foreground}

        line-wrong-color=${colors.background}
        inside-wrong-color=${colors.urgent}
        ring-wrong-color=${colors.urgent}

        line-ver-color=${colors.background}
        inside-ver-color=${colors.background}
        ring-ver-color=${colors.background}

        grace=30
        screenshots
        fade-in=0.15
        effect-pixelate=20
        indicator-radius=50
      '');
    };
  };
}
