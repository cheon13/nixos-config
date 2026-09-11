# Nextcloud sur « serveur ».
#
# Le mot de passe administrateur vient de sops-nix et non plus du dépôt.
# Il y a séjourné en clair (introduit par le commit 5f1f8a6), dans un dépôt
# public : l'ancien doit être considéré comme compromis, et le remplacer ici
# ne suffit pas à le révoquer.
#
# PIÈGE, à ne pas oublier lors d'une rotation : `adminpassFile' n'est lu
# qu'à la CRÉATION de l'instance. Le module nixpkgs entoure l'installation
# d'un test « if [[ ! -s <datadir>/config/config.php ]] », donc sur une
# instance déjà installée, changer ce fichier ne touche pas au mot de passe
# réel — il vit dans la base de données. Pour le changer pour de bon :
#
#     sudo nextcloud-occ user:resetpassword root
#
# Le compte s'appelle « root » et non « admin » : c'est la valeur par défaut
# de services.nextcloud.config.adminuser. Comme le nom d'utilisateur sert
# d'identifiant interne à Nextcloud, il est fixé à l'installation et ne peut
# plus changer — inutile de le redéfinir ici.
#
# Ce fichier ne sert donc qu'à deux choses : une réinstallation depuis zéro,
# et garder une trace déclarative du mot de passe courant.

{ config, pkgs, ... }:
{
  # Déchiffré vers /run/secrets au démarrage. Le module le passe à systemd
  # via LoadCredential, qui le lit en root : les droits par défaut de
  # sops-nix (root:root, 0400) conviennent, inutile de les élargir.
  sops.secrets.nextcloud_admin_pass = { };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud33;
    hostName = "10.0.0.200";
    config.adminpassFile = config.sops.secrets.nextcloud_admin_pass.path;
    config.dbtype = "mysql";
    database.createLocally = true;
    extraApps = {
      inherit (pkgs.nextcloud33Packages.apps) notes;
    };
    extraAppsEnable = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}
