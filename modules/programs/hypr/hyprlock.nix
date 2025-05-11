{
  config,
  lib,
  options,
  pkgs,
  ...
}: {
  options.mods.hypr.hyprlock = {
    enable = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
      description = "Enables Hyprlock";
    };
    config = lib.mkOption {
      default = {
        background = [
          {
            monitor = "";
            path = "";
            color = "rgba(26, 27, 38, 1.0)";
          }
        ];

        input-field = [
          {
            monitor = "${config.mods.hypr.hyprland.defaultMonitor}";
            placeholder_text = "password or something";
          }
        ];

        label = [
          {
            monitor = "${config.mods.hypr.hyprland.defaultMonitor}";
            text = "$TIME";
            font_size = 50;
            position = "0, 200";
            valign = "center";
            halign = "center";
          }
        ];
      };
      example = {};
      type = with lib.types; attrsOf anything;
      description = "config";
    };
  };

  config = lib.mkIf config.mods.hypr.hyprlock.enable (
    lib.optionalAttrs (options ? xdg.configFile) {
      stylix.targets.hyprlock = {
        enable = false;
      };
      home.packages = with pkgs; [hyprlock];
      programs.hyprlock = lib.mkIf config.mods.hypr.hyprlock.enable {
        enable = true;
        settings = config.mods.hypr.hyprlock.config;
      };
    }
  );
}
