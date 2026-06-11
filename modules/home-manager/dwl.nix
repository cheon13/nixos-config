{ config, ... }:

{
  # Scripts et fichiers de configuration de dwl (~/.config/dwl).
  # Lien symbolique mutable vers le dépôt : éditable sur place sans rebuild.
  xdg.configFile."dwl" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/home-manager/config/dwl";
    #recursive = true;
  };
}
