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
        #"portable" = { id = "WOSHMB7-N5YIJTM-VLAPPHS-HUQS2QO-CEO67WO-MF4LJIW-4HGO563-LPEVCAZ"; };
        "portable" = { id = "2H6R2EE-GUGFVTC-EJ2PJV6-EGU3F3J-J32ZAGY-VG3V5Z6-CLRI2G2-T7GIIA5"; };
        "serveur" = { id = "ZXIDF7N-OYKKYUC-XV4MJEB-TT5G7TL-Q32AGSN-PE3GQJ6-3QYZQIJ-3646AQU"; };
        "phone" = { id = "WNJ5NHU-FCEJGLJ-TBESUFK-XPMKGBN-H225KSH-JZB7XB5-FGAQUWH-4WXIVQF"; };
        "DESKTOP-UEM9CA3" = { id = "FWKDNXG-UIMQA6F-FTBAGSP-VKD34DH-DFGQDWO-ZOPEKOJ-KV54A6J-IVU44AM"; };
      };
      settings.folders = {
        "Cerveau" = { 
          id = "mbh3e-b0zp2";
          path = "/home/cheon/Documents/Cerveau"; 
          #devices = ["phone" "DESKTOP-UEM9CA3"]; 
          devices = [ "portable" "serveur" "phone" "DESKTOP-UEM9CA3"]; 
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
