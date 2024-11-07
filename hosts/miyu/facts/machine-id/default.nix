{
  config,
  lib,
  ...
}:

let
  machineId = lib.strings.trim (builtins.readFile ./machine-id);
in
{
  boot.kernelParams = [
    "systemd.machine_id=${machineId}"
  ];

  environment.etc."machine-id" = {
    text = machineId + "\n";
  };
}
