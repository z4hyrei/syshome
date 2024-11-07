{
  config,
  lib,
  ...
}:

let
  mutableHomeDir = "${config.home.homeDirectory}/mhome";

  desktopDir = "${mutableHomeDir}";
  downloadsDir = "${mutableHomeDir}/downloads";

  mediasDir = "${mutableHomeDir}/medias";
  imagesDir = "${mediasDir}/images";
  musicsDir = "${mediasDir}/musics";
  videosDir = "${mediasDir}/videos";
  documentsDir = "${mediasDir}/documents";

  gamesDir = "${mutableHomeDir}/games";
  worksDir = "${mutableHomeDir}/workspace";
  screenshotsDir = "${imagesDir}/screenshots";
  screencastsDir = "${videosDir}/screencasts";
in
{
  xdg.enable = true;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    # Base directories.
    desktop = desktopDir;
    download = downloadsDir;

    # Media-related directories.
    pictures = imagesDir;
    music = musicsDir;
    videos = videosDir;
    documents = documentsDir;

    # Unused directories. What are they even for.
    templates = null;
    publicShare = null;

    # Personal custom directories.
    extraConfig = {
      XDG_GAMES_DIR = gamesDir;

      XDG_WORKS_DIR = worksDir;
      XDG_WORKSPACE_DIR = worksDir;

      XDG_SCREENSHOT_DIR = screenshotsDir;
      XDG_SCREENSHOTS_DIR = screenshotsDir;

      XDG_SCREENCAST_DIR = screencastsDir;
      XDG_SCREENCASTS_DIR = screencastsDir;
    };
  };

  # For faster navigation via `cd`.
  # e.g.: `cd ~works` or `cd ~dls`.
  programs.zsh.dirHashes = {
    home = mutableHomeDir;
    dls = downloadsDir;

    imgs = imagesDir;
    mucs = musicsDir;
    vids = videosDir;
    docs = documentsDir;

    games = gamesDir;
    works = worksDir;
  };

  # For GTK file dialog.
  gtk.gtk3.bookmarks = [
    "file://${desktopDir} Desktops"
    "file://${downloadsDir} Downloads"

    "file://${imagesDir} Images"
    "file://${musicsDir} Musics"
    "file://${videosDir} Videos"
    "file://${documentsDir} Documents"

    "file://${gamesDir} Games"
    "file://${worksDir} Workspace"

    "file://${screenshotsDir} Screenshots"
    "file://${screencastsDir} Screencasts"
  ];
}
