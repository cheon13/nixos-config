{ config, pkgs, lib, ... }:
{
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.httpd.enable = true;
  services.httpd.adminAddr = "cheon.cv@gmail.com";
  services.httpd.enablePHP = true; 

  services.httpd.virtualHosts."serveur" = {
    documentRoot = "/var/www/serveur";
    # want ssl + a let's encrypt certificate? add `forceSSL = true;` right here
  };

  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;

  # hacky way to create our directory structure and index page... don't actually use this
  #systemd.tmpfiles.rules = [
  #  "d /var/www/example.org"
  #  "f /var/www/example.org/index.php - - - - <?php phpinfo();"
  #];
}
