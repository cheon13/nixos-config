{ pkgs-unstable, ... }:

{
#  environment.systemPackages = with pkgs; [
#    pkgs-unstable.navidrome
#  ];

  # Service de music streaming
  services.navidrome = {
    enable = true;
    package = pkgs-unstable.navidrome;
    openFirewall = true;
    settings = {
      Address = "10.0.0.200";
      Port = 4533;
      MusicFolder = "/var/Navidrome-music";
      EnableSharing = true;
    };
  };
}
