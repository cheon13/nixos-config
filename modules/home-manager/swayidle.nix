# swayidle.nix

## Notes: finalement, j'ai décidé de ne pas utiliser swayidle sous forme de service.
## J'appelle maintenant swayidle directement dans les fichiers de configuration de
## sway et d'hyprland. C'est plus simple et plus stable.

{ pkgs, lib, config, ... }:

let
  swaylock = "${config.programs.swaylock.package}/bin/swaylock";
  pgrep = "${pkgs.procps}/bin/pgrep";
  pactl = "${pkgs.pulseaudio}/bin/pactl";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  swaymsg = "${config.wayland.windowManager.sway.package}/bin/swaymsg";

  isLocked = "${pgrep} -x ${swaylock}";
  lockTime = 4 * 60; # TODO: configurable desktop (10 min)/laptop (4 min)

  # Makes two timeouts: one for when the screen is not locked (lockTime+timeout) and one for when it is.
  afterLockTimeout = { timeout, command, resumeCommand ? null }: [
    { timeout = lockTime + timeout; inherit command resumeCommand; }
    { command = "${isLocked} && ${command}"; inherit resumeCommand timeout; }
  ];
in
{
  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    timeouts =
      # Lock screen
      [{
        timeout = lockTime;
        command = "${swaylock} --daemonize";
        #command = "${swaylock} --daemonize --grace 15";
      }] ++
      # Mute mic
      #(afterLockTimeout {
      #  timeout = 10;
      #  command = "${pactl} set-source-mute @DEFAULT_SOURCE@ yes";
      #  resumeCommand = "${pactl} set-source-mute @DEFAULT_SOURCE@ no";
      #}) ++
       Turn off displays (hyprland)
      (lib.optionals config.wayland.windowManager.hyprland.enable (afterLockTimeout {
        timeout = 40;
        command = "${hyprctl} dispatch dpms off";
        resumeCommand = "${hyprctl} dispatch dpms on";
      })) ++
       Turn off displays (sway)
      (lib.optionals config.wayland.windowManager.sway.enable (afterLockTimeout {
        timeout = 40;
        command = "${swaymsg} 'output * dpms off'";
        resumeCommand = "${swaymsg} 'output * dpms on'";
      }));
  };
}


#{ config, pkgs, ... }:
#
#{
#
#  services.swayidle = {
#    enable = true;
#    timeouts = [
#      {
#        timeout = 295;
#        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 5 seconds' -t 5000";
#      }
#      {
#        timeout = 300;
#        command = "${pkgs.swaylock}/bin/swaylock";
#      }
#      {
#        timeout = 360;
#        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
#        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
#      }
#    ];
#    events = [
#      {
#        event = "before-sleep";
#        command = "${pkgs.swaylock}/bin/swaylock";
#      }
#    ];
#  };   
#
#}
#
