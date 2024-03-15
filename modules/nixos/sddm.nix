{ pkgs, ... }:

{
  # Installation du display manager sddm
  services.xserver.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    theme = "${import ./sddm-theme.nix { inherit pkgs; }}";
    #theme = "chili";
  }; 
  
  environment.systemPackages = [
    pkgs.sddm-chili-theme
  ];
}
