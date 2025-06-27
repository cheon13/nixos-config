{config, pkgs, ...}:

{
  # Service de synchronisation Syncthing
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
      settings.devices = {
        "portable-dominique" = { id = "ATG2335-BJBH5IY-3QZWKG2-GX6HH63-OLAC3WY-7DCT6F5-J3JKK7R-I23XKA5"; };
        "portable" = { id = "2H6R2EE-GUGFVTC-EJ2PJV6-EGU3F3J-J32ZAGY-VG3V5Z6-CLRI2G2-T7GIIA5"; };
        "serveur" = { id = "ZXIDF7N-OYKKYUC-XV4MJEB-TT5G7TL-Q32AGSN-PE3GQJ6-3QYZQIJ-3646AQU"; };
        "phone" = { id = "WNJ5NHU-FCEJGLJ-TBESUFK-XPMKGBN-H225KSH-JZB7XB5-FGAQUWH-4WXIVQF"; };
      };
      settings.folders = {
        "Cerveau" = { 
          id = "mbh3e-b0zp2";
          path = "/home/cheon/Documents/Cerveau"; 
          devices = [ "portable" "serveur" "phone"]; 
          versioning = { 
            type = "simple"; 
            params = { 
              keep = "10"; 
            }; 
          }; 
        };
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
