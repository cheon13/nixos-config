{
  services.actual = {
    enable = true;
    openFirewall = true;
    settings = {
      https = { # Il faut bien s'assurer que les deux fichiers sont lisibles par l'usager actual
        cert = "/home/cheon/.config/actualbudget/certificats/moncertificat-CA.crt";
        key  = "/home/cheon/.config/actualbudget/certificats/moncertificat-CA.key";
        };
    };
  };
}
