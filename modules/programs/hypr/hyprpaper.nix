{
  config,
  lib,
  options,
  pkgs,
  ...
}: {
  options.mods.hypr.hyprpaper = {
    enable = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
      description = "Enables Hyprpaper";
    };
    config = lib.mkOption {
      default = "";
      example = ''
        preload = path/to/wallpaper
        wallpaper = YOURMONITOR,path/to/wallpaper
      '';
      type = lib.types.lines;
      description = ''
        Hyprpaper config
      '';
    };
  };

  config = lib.mkIf config.mods.hypr.hyprpaper.enable (
    lib.optionalAttrs (options ? xdg.configFile) {
      home.packages = with pkgs; [hyprpaper];
      xdg.configFile."hypr/hyprpaper.conf" = lib.mkIf config.mods.hypr.hyprpaper.enable {
        text = config.mods.hypr.hyprpaper.config;
      };
    }
  );
}
