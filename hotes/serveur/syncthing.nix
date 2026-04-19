{ ... }:

{
  imports = [
    ../../modules/nixos/syncthing.nix
  ];

  # Service de synchronisation Syncthing
  services.syncthing = {
      settings.folders = {
        # Répertoire spécifique à serveur et au portable-dominique
        "musique-dominique" = { 
          id = "hnkxk-d5dgu";
          path = "/var/Navidrome-music/Dominique/"; 
          devices = [ "portable-dominique" "serveur"]; 
          versioning = { 
            type = "simple"; 
            params = { 
              keep = "10"; 
            }; 
          }; 
        };
      };
  };

}
