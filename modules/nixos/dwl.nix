{ pkgs, ... }:

{
  # paquets nécessaires pour compiler et utiliser DWL

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    pkg-config
    wayland-scanner
    wayland
    wayland-protocols
    wlroots_0_19
    foot
    wmenu
    wl-clipboard
    grim
    slurp
    swaybg
    dwlb     # barre wayland semblable à la barre dwm
  ];
}
