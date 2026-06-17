# kmscon.nix
#
# Remplace l'agetty classique par kmscon sur les consoles virtuelles (tty).
# kmscon affiche les polices TrueType et gère mieux l'Unicode que la console
# Linux par défaut.

{ pkgs, lib, ... }:

{
  services.kmscon = {
    enable = true;

    # Police monospace Adwaita (paquet adwaita-fonts), taille 16.
    # La taille n'a pas d'option dédiée : on la fixe via extraConfig.
    fonts = [
      {
        name = "Adwaita Mono";
        package = pkgs.adwaita-fonts;
      }
    ];
    extraConfig = ''
      font-size=16
    '';

    # Réutilise la disposition clavier de services.xserver.xkb,
    # c.-à-d. fr / ergol (voir modules/nixos/default.nix).
    useXkbConfig = true;
  };

  # ---------------------------------------------------------------------------
  # Console texte dédiée pour lancer dwl (Ctrl+Alt+F7)
  #
  # kmscon dessine via DRM et garde le « DRM master » sur son VT. dwl (wlroots)
  # ne peut donc pas démarrer depuis une console kmscon : sa session n'arrive
  # jamais à devenir active sur le seat (« Timeout waiting session to become
  # active »). Une console texte agetty, elle, ne tient pas le DRM : dwl peut
  # y prendre le master normalement (comme avant kmscon).
  #
  # Le module kmscon alias autovt@ -> kmsconvt@ pour TOUS les VT, mais logind
  # ne déclenche autovt@ttyN que pour les VT 1 à NAutoVTs (6 par défaut). On
  # place donc ce getty sur tty7, hors de cette plage : kmscon ne l'atteint
  # jamais et ce VT reste une vraie console texte d'où lancer `startdwl`.
  systemd.services."getty-dwl" = {
    description = "Console texte sur tty7 pour lancer dwl manuellement";
    after = [
      "systemd-user-sessions.service"
      "plymouth-quit-wait.service"
      "getty-pre.target"
    ];
    wantedBy = [ "multi-user.target" ];
    restartIfChanged = false;
    serviceConfig = {
      ExecStart = "${lib.getExe' pkgs.util-linux "agetty"} --login-program ${pkgs.shadow}/bin/login --noclear --keep-baud tty7 115200,38400,9600 linux";
      Type = "idle";
      Restart = "always";
      UtmpIdentifier = "tty7";
      TTYPath = "/dev/tty7";
      TTYReset = "yes";
      TTYVHangup = "yes";
      TTYVTDisallocate = "yes";
      KillMode = "process";
      IgnoreSIGPIPE = "no";
      SendSIGHUP = "yes";
    };
  };
}
