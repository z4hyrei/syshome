{
  config,
  lib,
  pkgs,
  self,
  inputs,
  ...
}:

let
  userName = "z4hyrei";
  userHome = "/home/${userName}";
  displayName = "z4hy零";
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops
  ];

  users.users.${userName} = {
    isNormalUser = true;

    name = userName;
    home = userHome;
    description = displayName;

    extraGroups = [
      "wheel"
      "audio"
      "video"
    ];

    shell = pkgs.zsh;

    hashedPasswordFile = config.sops.secrets.z4hyrei-password.path;
  };

  home-manager.users.${userName} = {
    imports = [
      (self.outPath + "/homes/z4hyrei")
    ];

    home.username = lib.mkForce userName;
    home.homeDirectory = lib.mkForce userHome;
  };

  sops.secrets.z4hyrei-password = {
    sopsFile = (self.outPath + "/secrets/z4hyrei-password/secret.yaml");
    format = "yaml";
    neededForUsers = true;
  };

  programs.zsh.enable = lib.mkForce true;
}
