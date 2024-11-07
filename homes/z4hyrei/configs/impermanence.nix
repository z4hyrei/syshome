{
  config,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.impermanence.homeManagerModules.impermanence
  ];

  home.persistence."/persist/${config.home.homeDirectory}" = {
    allowOther = true;

    directories = [
      "mhome"
      ".gnupg"
      ".ssh"
    ];
  };
}
