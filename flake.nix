{
  description = "My personal system-wide configurations";

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { self, withSystem, ... }:
      {
        systems = import inputs.systems;

        flake = {
          nixosConfigurations.miyu = withSystem "x86_64-linux" (
            ctx@{ config, ... }:
            inputs.nixpkgs.lib.nixosSystem {
              inherit (ctx) system;
              specialArgs = {
                inherit self inputs;
                inherit (ctx) self' inputs';
              };
              modules = [ ./hosts/miyu ];
            }
          );

          homeConfigurations."z4hyrei@miyu" = withSystem "x86_64-linux" (
            ctx@{ config, ... }:
            inputs.home-manager.lib.homeManagerConfiguration {
              inherit (ctx) pkgs;
              specialArgs = {
                inherit self inputs;
                inherit (ctx) self' inputs';
              };
              modules = [ ./homes/z4hyrei ];
            }
          );
        };

        perSystem =
          ctx@{ config, pkgs, ... }:
          {
            devShells.default = pkgs.mkShellNoCC {
              packages = [
                pkgs.sops
                pkgs.age
                pkgs.ssh-to-age
              ];
            };
          };
      }
    );

  inputs = {
    nixpkgs.follows = "nixpkgs-unstable";
    systems.url = "github:nix-systems/default-linux";

    #
    # Nix packages
    #

    nixpkgs-released.url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    #
    # Flake utilities
    #

    flake-compat.url = "github:edolstra/flake-compat";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    #
    # System modules
    #

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-released";
    };

    srvos = {
      url = "github:nix-community/srvos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
