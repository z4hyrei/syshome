{
  config,
  pkgs,
  ...
}:

{
  home.packages = [
    # Required fonts.
    pkgs.sarasa-gothic
    pkgs.julia-mono
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    enableUpdateCheck = false;
    enableExtensionUpdateCheck = false;

    userSettings = {
      "update.showReleaseNotes" = false;
      "telemetry.telemetryLevel" = "off";

      #
      # Files configs
      #

      "files.eol" = "\n";
      "files.encoding" = "utf8";

      "files.trimFinalNewlines" = true;
      "files.insertFinalNewline" = true;
      "files.trimTrailingWhitespace" = true;

      #
      # Editor configs
      #

      "editor.fontSize" = 16;
      "editor.fontFamily" = "'Sarasa Term J SemiBold', 'JuliaMono', monospace";
      "editor.fontLigatures" = true;

      # Show rulers to indicate whether the line is too long.
      "editor.rulers" = [
        80
        120
      ];

      # Show whitespaces if there are hard tabs or more than 2 spaces.
      "editor.renderWhitespace" = "boundary";
    };
  };
}
