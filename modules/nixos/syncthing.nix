{config, pkgs, ...}:

{
  # Service de synchronisation Syncthing - configuration commune à tous mes ordis
  services.syncthing = {
    enable = true;
    dataDir = "/home/cheon/Documents";
    openDefaultPorts = true;
    configDir = "/home/cheon/.config/syncthing";
    user = "cheon";
    #group = "users";
    guiAddress = "127.0.0.1:8384";
      overrideDevices = true;
      overrideFolders = true;

      # Synchronisation strictement locale (LAN).
      # Sans ces réglages, Syncthing maintient en permanence une connexion vers
      # un relais public tiers (pool relays.syncthing.net) même sans transfert :
      # ce sont ces contacts vers des VPS inconnus qui déclenchaient les alertes
      # de réputation d'IP du routeur. La découverte locale (localAnnounce)
      # reste active : elle seule suffit sur le réseau domestique.
      # Conséquence : un appareil hors du LAN (le téléphone) ne se synchronise
      # plus tant qu'il n'est pas revenu sur le réseau.
      settings.options = {
        relaysEnabled = false;
        globalAnnounceEnabled = false;
      };

      settings.devices = {
        "portable-dominique" = { id = "ATG2335-BJBH5IY-3QZWKG2-GX6HH63-OLAC3WY-7DCT6F5-J3JKK7R-I23XKA5"; };
        "portable" = { id = "2H6R2EE-GUGFVTC-EJ2PJV6-EGU3F3J-J32ZAGY-VG3V5Z6-CLRI2G2-T7GIIA5"; };
        "serveur" = { id = "ZXIDF7N-OYKKYUC-XV4MJEB-TT5G7TL-Q32AGSN-PE3GQJ6-3QYZQIJ-3646AQU"; };
        "phone" = { id = "WNJ5NHU-FCEJGLJ-TBESUFK-XPMKGBN-H225KSH-JZB7XB5-FGAQUWH-4WXIVQF"; };
        "pomme" = { id = "MPXHJEW-S2FFUMH-DDHBTUQ-7XASW3S-RBJ3ZOE-QVR3CWG-QEW2FEB-4CRLBAE"; };
      };

      settings.folders = {
        "Cerveau" = { 
          id = "mbh3e-b0zp2";
          path = "/home/cheon/Documents/Cerveau"; 
          devices = [ "portable" "serveur" "phone" "pomme" ]; 
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
