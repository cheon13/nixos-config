{ pkgs, ... }:
{
  environment.etc."nextcloud-admin-pass".text = "Ceciestuntestnextcloud";
  
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "serveur";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "sqlite";
  };
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

