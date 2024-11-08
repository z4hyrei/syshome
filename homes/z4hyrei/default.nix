{
  config,
  lib,
  pkgs,
  ...
}:

let
  userName = "z4hyrei";
  userHome = "/home/${userName}";
in
{
  imports = [
    ./configs/impermanence.nix
    ./configs/stateVersion.nix

    ./configs/brave.nix
    ./configs/xdg.nix

    ./configs/hyprland.nix
    ./configs/fuzzel.nix
    ./configs/foot.nix

    ./configs/vscode.nix
  ];

  home.username = lib.mkDefault userName;
  home.homeDirectory = lib.mkDefault userHome;

  programs.home-manager.enable = true;

  fonts = {
    fontconfig.enable = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    history = {
      path = "${config.xdg.stateHome}/zsh/cmd_history";
      size = 10000;
      save = 20000;
    };

    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
  };

  programs.eza = {
    enable = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };

  programs.bat = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;

    userName = "Nguyen Gia Huy";
    userEmail = "vcs@z4hyrei.dev";

    lfs.enable = true;

    extraConfig = {
      init.defaultBranch = "main";

      user.signingkey = "FB6E9269459BE438!";

      tag.gpgSign = true;
      commit.gpgSign = false;
    };

    ignores = [
      "*~"
      "*.swp"
      "*.vscode"
      "*.idea"
    ];
  };

  programs.gpg = {
    enable = true;

    settings = {
      display-charset = "utf-8";
      no-greeting = true;

      default-cert-expire = "1y";
      default-new-key-algo = "ed25519/cert";

      s2k-mode = "3";
      s2k-count = "65011712";

      trust-model = "tofu+pgp";
      tofu-default-policy = "unknown";
    };
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };
}
