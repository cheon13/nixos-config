{ pkgs, ... }:{

  home.packages = [ pkgs.hyprpaper ];
  
  xdg.configFile."hypr/wallpaper".source = ./wallpaper;
  
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.config/hypr/wallpaper/bridge.jpg
    wallpaper = ,~/.config/hypr/wallpaper/bridge.jpg
  '';

  systemd.user.services.hyprpaper = {
    Unit = { Description = "hyprpaper"; };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpaper}/bin/hyprpaper";
      Restart = "on-failure";
    };
    Install = { WantedBy = [ "hyprland-session.target" ]; };
  };
}

