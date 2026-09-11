# Secrets de synchronisation des calendriers (org-caldav / org-gcal).
#
# Quatre secrets, tous des VALEURS : aucun ne contient de code. init.el garde
# l'intégralité de la logique et se lit sans rien déchiffrer — ce qui manque
# à la lecture, ce sont les valeurs, pas le raisonnement.
#
#   calendrier-authinfo      Fichier au format netrc, deux lignes. Le format
#                            n'est pas un choix : org-caldav s'authentifie via
#                            le paquet `url' d'Emacs, qui ne consulte que
#                            auth-source, lequel ne lit qu'un netrc. Le couple
#                            client OAuth2 de Google y tient aussi, étant lui
#                            aussi une paire identifiant/secret.
#
#                              machine calendar.<domaine-zoho>:443 port https
#                                login <adresse zoho> password <mdp application>
#                              machine org-gcal port https
#                                login <client id> password <client secret>
#
#   calendrier-zoho-id       Identifiant du calendrier professionnel, tiré du
#                            chemin de la CalDAV URL fournie par Zoho — et non
#                            le « Calendar ID » que Zoho affiche à côté, qui
#                            sert aux abonnements ICS.
#   calendrier-gcal-perso    Identifiant du calendrier Google personnel.
#   calendrier-gcal-famille  Identifiant du calendrier Google familial partagé.
#
# Ces trois derniers ne sont pas des secrets au sens strict : seuls, ils ne
# compromettent rien. Ils sont ici parce que le dépôt est public et qu'une
# adresse personnelle ou un calendrier familial n'ont pas à y figurer.
#
# Importé par portable et pomme seulement : le serveur n'a aucune raison de
# détenir ces identifiants.
#
# Procédure de première mise en place : docs/synchronisation-calendriers.org.

{ ... }:
let
  # Lisible par cheon, qui fait tourner Emacs — et par personne d'autre.
  pourEmacs = {
    owner = "cheon";
    mode = "0400";
  };
in
{
  sops.secrets = {
    "calendrier-authinfo" = pourEmacs;
    "calendrier-zoho-id" = pourEmacs;
    "calendrier-gcal-perso" = pourEmacs;
    "calendrier-gcal-famille" = pourEmacs;
  };
}
