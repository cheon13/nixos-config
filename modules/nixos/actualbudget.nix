{
  services.actual = {
    enable = true;
    openFirewall = true;
    settings = {
      https = { # Il faut bien s'assurer que les deux fichiers sont lisibles par l'usager actual
      cert = "/etc/nixos/certificats/moncertificat-CA.crt";
      key  = "/etc/nixos/certificats/moncertificat-CA.key";
        };
    };
  };
}
