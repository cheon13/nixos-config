{ config, pkgs, ... }:

{
  # Configuration de la waybar
  programs.waybar = {
      enable = true;
      settings =  {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          #output = [
          #   "eDP-1"
          #  "HDMI-A-1"
          #];
          modules-left = [ "sway/workspaces"  "sway/mode" ];
          modules-center = [ "sway/window" ];
          modules-right = [ "idle_inhibitor" "pulseaudio" "network" "tray" "clock"];
          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
          };
	  "sway/mode" = {
              format = " {}";
              max-length = "50";
          };
          "clock" = {
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
              format-alt = "{:%Y-%m-%d}";
          };
          "idle_inhibitor" = {
              format = "{icon}";
              format-icons = {
                  activated = "";
                  deactivated = "";
              };
          };
          "pulseaudio" = {
              format = "{volume}% {icon} {format_source}";
              format-bluetooth = "{volume}% {icon} {format_source}";
              format-bluetooth-muted = " {icon} {format_source}";
              format-muted =  " {format_source}";
              format-source =  "{volume}% ";
              format-source-muted =  "";
              format-icons =  {
                  headphone =  "";
                  hands-free =  "";
                  headset =  "";
                  phone =  "";
                  portable =  "";
                  car =  "";
                  default = "";
              };
              on-click = "pavucontrol";
          };
          "network" = {
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "{ipaddr}/{cidr} ";
              tooltip-format = "{ifname} via {gwaddr} ";
              format-linked = "{ifname} (No IP) ";
              format-disconnected = "Disconnected ⚠";
              format-alt = "{ifname}: {ipaddr}/{cidr}";
          };
        };  
      };
      style = ''
        * {
            font-family: JetBrainsMono;
            font-size: 15px;
            border: none;
            border-radius: 0;
            min-height: 0;
            margin: 1px;
            padding: 0;
        }

        window#waybar {
            background: transparent;
            background-color: rgba(50, 50, 50, 0.5);
            color: #ebdbb2;
        }

        button {
            box-shadow: inset 0 -3px transparent;
            border: none;
            border-radius: 0;
        }
        
        button:hover {
            background: inherit;
            box-shadow: inset 0 -3px #ebdbb2;
        }
        
        #workspaces button {
            padding: 0 5px;
            background-color: transparent;
            color: #ebdbb2;
        }
        
        #workspaces button:hover {
            background: rgba(0, 0, 0, 0.2);
        }
        
        #workspaces button.focused {
            border:  1px solid;
            border-color: #ebdbb2;
        }
        
        #workspaces button.active {
            border:  1px solid;
            border-color: #ebdbb2;
        }
        
        #workspaces button.urgent {
            background-color: #eb4d4b;
        }
        #clock,
        #network,
        #pulseaudio,
        #wireplumber,
        #custom-media,
        #tray,
        #idle_inhibitor {
            padding: 0 10px;
            color: #ebdbb2;
        }
        
        #window,
        #workspaces {
            padding:0 1px;
            margin: 1px 0px;
        }
        '';
  };

  xdg.configFile."waybar/config.hyprland".text = ''
[
  {
    "clock": {
      "format-alt": "{:%Y-%m-%d}",
      "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>"
    },
    "height": 30,
    "idle_inhibitor": {
      "format": "{icon}",
      "format-icons": {
        "activated": "",
        "deactivated": ""
      }
    },
    "layer": "top",
    "modules-center": [
      "hyprland/window"
    ],
    "modules-left": [
      "hyprland/workspaces",
    ],
    "modules-right": [
      "idle_inhibitor",
      "pulseaudio",
      "network",
      "tray",
      "clock"
    ],
    "network": {
      "format-alt": "{ifname}: {ipaddr}/{cidr}",
      "format-disconnected": "Disconnected ⚠",
      "format-ethernet": "{ipaddr}/{cidr} ",
      "format-linked": "{ifname} (No IP) ",
      "format-wifi": "{essid} ({signalStrength}%) ",
      "tooltip-format": "{ifname} via {gwaddr} "
    },
    //"output": [
    //  "HDMI-A-1"
    //],
    "position": "top",
    "pulseaudio": {
      "format": "{volume}% {icon} {format_source}",
      "format-bluetooth": "{volume}% {icon} {format_source}",
      "format-bluetooth-muted": " {icon} {format_source}",
      "format-icons": {
        "car": "",
        "default": "",
        "hands-free": "",
        "headphone": "",
        "headset": "",
        "phone": "",
        "portable": ""
      },
      "format-muted": " {format_source}",
      "format-source": "{volume}% ",
      "format-source-muted": "",
      "on-click": "pavucontrol"
    },
    "hyprland/workspaces": {
      "all-outputs": true,
      "disable-scroll": true
    }
  }
]
  '';


}

