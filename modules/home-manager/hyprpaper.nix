{ pkgs, ... }:{

  home.packages = [ pkgs.hyprpaper ];
  
  # xdg.configFile."hypr/Wallpapers".source = ./Wallpapers;
  # Il faut faire le backup des images du répertoire de Wallpapers

  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/Images/Wallpapers/hyprlandWP.jpg
    wallpaper = ,~/Images/Wallpapers/hyprlandWP.jpg
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

