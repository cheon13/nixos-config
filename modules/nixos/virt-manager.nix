# Module NixOS pour la virtualisation avec virt-manager

{ ... }:

{
  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  users.users.cheon.extraGroups = [ "libvirtd" ];
}
