{ pkgs, config, ... }: {
  # Outils disponibles sur toutes les machines
  environment.systemPackages = with pkgs; [
    age
    ssh-to-age
    sops
  ];

  sops = {
    defaultSopsFile = ../../../secrets/common/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets.user_password = {
      neededForUsers = true;
    };
  };
}
