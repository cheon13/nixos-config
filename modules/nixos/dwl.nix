{ pkgs, dwlSrc, ... }:

let
  # Build de mon fork personnel de DWL.
  # Les sources viennent de l'input flake `mon-dwl` (branche mon-dwl).
  # La dérivation reproduit le build du flake du fork : wlroots 0.19, sans XWayland.
  mon-dwl = pkgs.stdenv.mkDerivation {
    pname = "mon-dwl";
    version = "mon-dwl";

    src = dwlSrc;

    nativeBuildInputs = with pkgs; [
      pkg-config
      wayland-scanner
    ];

    buildInputs = with pkgs; [
      wayland
      wayland-protocols
      wlroots_0_19
      libxkbcommon
      pixman
      libinput
    ];

    makeFlags = [
      "PREFIX=$(out)"
      "MANDIR=$(out)/share/man"
    ];

    meta = with pkgs.lib; {
      description = "dwm pour Wayland — fork personnel";
      homepage = "https://github.com/cheon13/mon-dwl";
      license = licenses.gpl3Only;
      platforms = platforms.linux;
      mainProgram = "dwl";
    };
  };
in
{
  # mon-dwl + tous les outils invoqués par dwl et ses scripts (~/.config/dwl).
  # bemenu (le lanceur principal) est fourni à part par programs.bemenu (home-manager),
  # et slstatus — qui alimente dwlb — est compilé par hôte dans hotes/<machine>.
  environment.systemPackages = with pkgs; [
    mon-dwl
    foot        # terminal lancé par dwl
    dwlb        # barre wayland semblable à la barre dwm
    wmenu       # lanceur secondaire (menus dwl)
    swaybg      # fond d'écran
    grim        # capture d'écran
    slurp       # sélection de zone pour grim
    wl-clipboard
    wlopm       # gestion de l'alimentation des écrans (économiseur d'écran)
    hyprpicker  # pipette : sélectionner une couleur à l'écran
  ];
}
