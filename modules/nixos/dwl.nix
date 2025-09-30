{ pkgs, ... }:

{
  # paquets nécessaires pour compiler et utiliser DWL

  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    wayland
    wayland-protocols
    wlroots_0_19
    foot
    wmenu
    wl-clipboard
    grim
    slurp
    swaybg
  ];
}
