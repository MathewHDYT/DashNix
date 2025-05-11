{
  lib,
  config,
  options,
  pkgs,
  ...
}: {
  options.mods.ncspot = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = "Enables ncspot with a config";
    };
    config = lib.mkOption {
      default = {
        notify = true;
        shuffle = true;
        cover_max_scale = 2;
        initial_screen = "library";
        library_tabs = ["playlists"];
        theme = {
          background = "#1a1b26";
          primary = "#9aa5ce";
          secondary = "#414868";
          title = "#9ece6a";
          playing = "#7aa2f7";
          playing_selected = "#bb9af7";
          playing_bg = "#24283b";
          highlight = "#c0caf5";
          highlight_bg = "#24283b";
          error = "#414868";
          error_bg = "#f7768e";
          statusbar = "#ff9e64";
          statusbar_progress = "#7aa2f7";
          statusbar_bg = "#1a1b26";
          cmdline = "#c0caf5";
          cmdline_bg = "#24283b";
          search_match = "#f7768e";
        };
        keybindings = {
          "j" = "move left 1";
          "k" = "move down 1";
          "l" = "move up 1";
          ";" = "move right 1";
        };
        notification_format = {
          title = "%artists";
          body = "%title";
        };
      };
      example = {};
      type = with lib.types; attrsOf anything;
      description = "config";
    };
  };
  config = lib.mkIf config.mods.ncspot.enable (
    lib.optionalAttrs (options ? home.packages) {
      home.packages = with pkgs; [ncspot];
      xdg.configFile."ncspot/config.toml".source =
        lib.mkIf config.mods.ncspot.useConfig (pkgs.formats.toml {}).generate "ncspot" config.mods.ncspot.config;
    }
  );
}
