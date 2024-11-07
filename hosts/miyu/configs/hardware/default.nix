{
  config,
  inputs,
  ...
}:

{
  imports = [
    ./disk.nix

    inputs.nixos-facter-modules.nixosModules.facter
    { config.facter.reportPath = ./facter.json; }
  ];
}
