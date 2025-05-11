{
  mkDashDefault,
  pkgs,
  lib,
  options,
  config,
  ...
}: {
  options.mods.dashfetch = {
    enable = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
      description = "A custom configuration for fastfetch";
    };
    modules = lib.mkOption {
      default = [
        "title"
        "separator"
        {
          type = "os";
          key = "OS";
          format = "DashNix ({name} {version})";
        }
        "host"
        "kernel"
        "uptime"
        "packages"
        "shell"
        "display"
        "de"
        "wm"
        "wmtheme"
        "theme"
        "icons"
        "font"
        "cursor"
        "terminal"
        "terminalfont"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "localip"
        "battery"
        "poweradapter"
        "locale"
        "break"
        "colors"
      ];
      example = [];
      type = with lib.types; listOf anything;
      description = "modules for fastfetch";
    };
  };

  config = lib.optionalAttrs (options ? home.packages) {
    xdg.configFile."fastfetch/config.jsonc" = lib.mkIf (config.mods.dashfetch.enable) {
      source = (pkgs.formats.json {}).generate "config.jsonc" {
        "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
        logo = {
          type = mkDashDefault "kitty";
          source = mkDashDefault ../../assets/logo2.png;
          width = mkDashDefault 35;
          padding = mkDashDefault {
            top = mkDashDefault 1;
          };
        };
        modules = config.mods.dashfetch.modules;
      };
    };
  };
}
