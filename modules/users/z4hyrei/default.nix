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

    # hashedPassword = "<Replace `mkpasswd` hashed password>";
  };

  home-manager.users.${userName} = {
    imports = [
      (self.outPath + "/homes/z4hyrei")
    ];

    home.username = lib.mkForce userName;
    home.homeDirectory = lib.mkForce userHome;
  };

  programs.zsh.enable = lib.mkForce true;
}
