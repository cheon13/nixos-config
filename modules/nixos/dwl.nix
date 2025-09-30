{ pkgs, ... }:

{
  # paquets nécessaires pour compiler et utiliser DWL

  environment.systemPackages = with pkgs; [
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
