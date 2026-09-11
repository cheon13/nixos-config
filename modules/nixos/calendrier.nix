# Secrets de synchronisation des calendriers (org-caldav / org-gcal).
#
# Deux secrets, parce que les deux outils lisent leurs identifiants de
# deux façons différentes — ce n'est pas un choix, c'est imposé :
#
#   - calendrier-authinfo : fichier au format netrc. org-caldav
#     s'authentifie auprès de Zoho via le paquet `url' d'Emacs, qui passe
#     par auth-source ; or auth-source ne sait lire qu'un netrc.
#
#   - calendrier-prive : fichier elisp chargé par init.el. Contient ce qui
#     n'est pas un mot de passe mais n'a pas sa place dans un dépôt public :
#     l'URL CalDAV de Zoho (elle porte un jeton de compte), les
#     identifiants des deux calendriers Google, et le couple client
#     id/secret OAuth2 d'org-gcal.
#
# Pas d'extension .el sur le second : sops-nix se sert du nom du secret
# comme clé dans le YAML, et un point y serait ambigu. init.el le charge
# donc avec `load-file', qui accepte un chemin sans extension.
#
# Importé par portable et pomme seulement : le serveur n'a aucune raison
# de détenir ces identifiants.
#
# Contenu attendu de chaque secret et procédure de première mise en place :
# docs/synchronisation-calendriers.org.

{ ... }:
{
  sops.secrets = {
    "calendrier-authinfo" = {
      owner = "cheon";
      mode = "0400";
    };

    "calendrier-prive" = {
      owner = "cheon";
      mode = "0400";
    };
  };
}
