{ pkgs, ... }:
{
  environment.etc."nextcloud-admin-pass".text = "9=UiSDr?Rcl>CK~JB=4B?4A]9";
  
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;
    hostName = "10.0.0.200";
    config.adminpassFile = "/etc/nextcloud-admin-pass";
    config.dbtype = "mysql";
  };
  
  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

