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
  # mon-dwl + les outils utilisés par dwl et ses scripts (~/.config/dwl)
  environment.systemPackages = with pkgs; [
    mon-dwl
    foot
    wmenu
    wl-clipboard
    grim
    slurp
    swaybg
    dwlb     # barre wayland semblable à la barre dwm
  ];
}
