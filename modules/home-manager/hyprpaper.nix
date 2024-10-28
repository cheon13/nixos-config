{ pkgs, ... }:{

  home.packages = [ pkgs.hyprpaper ];
  
  xdg.configFile."hypr/Wallpapers/hyprlaWP.jpg".source = ./Wallpapers/hyprlandWP.jpg;
  
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/.config/hypr/Wallpapers/hyprlandWP.jpg
    wallpaper = ,~/.config/hypr/Wallpapers/hyprlandWP.jpg
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

