let
  lockFile = builtins.fromJSON (builtins.readFile ./flake.lock);
  flakeCompat = import (fetchTarball {
    url =
      lockFile.nodes.flake-compat.locked.url
        or "https://github.com/edolstra/flake-compat/archive/${lockFile.nodes.flake-compat.locked.rev}.tar.gz";
    sha256 = lockFile.nodes.flake-compat.locked.narHash;
  }) { src = ./.; };
in
with flakeCompat;
shellNix.default // shellNix.devShells.${builtins.currentSystem}
