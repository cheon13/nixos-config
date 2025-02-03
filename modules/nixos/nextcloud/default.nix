{ pkgs, ... }:
{
  environment.etc."nextcloud-admin-pass".text = "Ceciestuntestnextcloud";
  
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "sqlite";
  };
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

