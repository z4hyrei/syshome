args@{
  config,
  lib,
  pkgs,
  self,
  inputs,
  ...
}:

let
  hostName = "miyu";
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.srvos.nixosModules.desktop
    inputs.srvos.nixosModules.mixins-systemd-boot
    inputs.srvos.nixosModules.mixins-terminfo
    inputs.srvos.nixosModules.mixins-trusted-nix-caches

    (self.outPath + "/modules/users/z4hyrei")

    ./configs/hardware
    ./configs/impermanence.nix
    ./configs/stateVersion.nix

    ./facts/machine-id
  ];

  networking.hostName = lib.mkDefault hostName;

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    initrd.systemd = {
      enable = true;
      network.enable = true;
    };
  };

  time = {
    timeZone = "Asia/Ho_Chi_Minh";
    hardwareClockInLocalTime = false;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8"
    ];
  };

  nix = {
    package = pkgs.nixVersions.latest;

    nixPath = [ "nixpkgs=${inputs.nixpkgs.outPath}" ];
    registry = {
      nixpkgs = {
        flake = inputs.nixpkgs;
      };
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +4";
    };

    settings = {
      flake-registry = "";
      warn-dirty = false;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  networking = {
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };

  users = {
    mutableUsers = false;
    users.root.hashedPassword = "!";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    extraSpecialArgs = {
      inherit (args)
        self
        inputs
        self'
        inputs'
        ;
    };
  };

  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;

    enableDefaultPackages = true;
    enableGhostscriptFonts = true;

    packages = [
      pkgs.sarasa-gothic
    ];
  };

  zramSwap = {
    enable = true;

    algorithm = "zstd";
    memoryPercent = 70;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };

    jack = {
      enable = true;
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  security.sudo.wheelNeedsPassword = false;

  services.openssh = {
    enable = true;

    hostKeys = [
      {
        type = "ed25519";
        rounds = 100;
        path = "/etc/ssh/ssh_host_ed25519_key";
      }
      {
        type = "rsa";
        bits = 4096;
        rounds = 100;
        path = "/etc/ssh/ssh_host_rsa_key";
      }
    ];
  };

  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    settings = {
      Theme.Font = "Sarasa Fixed J SemiBold";
    };
  };

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld;

    libraries = [
      pkgs.fontconfig
      pkgs.icu
      pkgs.openssl
      pkgs.stdenv.cc.cc
      pkgs.zlib
    ];
  };

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitMinimal;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
