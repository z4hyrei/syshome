{
  config,
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.brave
  ];

  home.persistence."/persist/${config.home.homeDirectory}" = {
    directories = [
      ".config/BraveSoftware"
    ];
  };
}
