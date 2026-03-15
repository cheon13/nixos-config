{ config, ... }:

{
  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/home-manager/config/niri";
    #recursive = true;
  };
   
}
