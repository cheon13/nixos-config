{ pkgs, ... }:
{
  environment.etc."nextcloud-admin-pass".text = "9=UiSDr?Rcl>CK~JB=4B?4A]9";
  
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "10.0.0.200";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "mysql";
    database.createLocally = true;
    extraApps = {
      inherit (pkgs.nextcloud31Packages.apps) notes;
    };
  extraAppsEnable = true;
  };
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

