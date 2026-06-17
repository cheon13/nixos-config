# kmscon.nix
#
# Remplace l'agetty classique par kmscon sur les consoles virtuelles (tty).
# kmscon affiche les polices TrueType et gère mieux l'Unicode que la console
# Linux par défaut.

{ pkgs, ... }:

{
  services.kmscon = {
    enable = true;

    # Police monospace Adwaita (paquet adwaita-fonts), taille 14.
    # La taille n'a pas d'option dédiée : on la fixe via extraConfig.
    fonts = [
      {
        name = "Adwaita Mono";
        package = pkgs.adwaita-fonts;
      }
    ];
    extraConfig = ''
      font-size=14
    '';

    # Réutilise la disposition clavier de services.xserver.xkb,
    # c.-à-d. fr / ergol (voir modules/nixos/default.nix).
    useXkbConfig = true;
  };
}
