{ pkgs, ... }:

{
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  environment.systemPackages = [
    pkgs.xwayland-satellite
  ];
}


