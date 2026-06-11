{ config, ... }:

{
  # Scripts et fichiers de configuration de dwl (~/.config/dwl).
  # Lien symbolique mutable vers le dépôt : éditable sur place sans rebuild.
  xdg.configFile."dwl" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/home-manager/config/dwl";
    #recursive = true;
  };

  # bemenu : lanceur principal de dwl (appelé par ses scripts).
  # Installé et configuré ensemble par ce module programs.bemenu.
  programs.bemenu = {
    enable = true;
    settings = {
      ignorecase = true;
      width-factor = 0.3;
      center = true;
      list = 20;
      fn = "JetBrainsMono 14";
      fb = "#282828";
      ff = "#ebdbb2";
      nb = "#282828";
      nf = "#ebdbb2";
      tb = "#282828";
      hb = "#282828";
      tf = "#fb4934";
      hf = "#fabd2f";
      af = "#ebdbb2";
      ab = "#282828";
      border = 1;
      bdr = "#ebdbb2";
    };
  };
}
