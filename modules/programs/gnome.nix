{
  lib,
  options,
  config,
  pkgs,
  ...
}:
{
  options.mods.gnome = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = "Enables the Gnome desktop environment";
    };
    useDefaultOptions = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
      description = "Use default options provided by module. If disabled, will only apply extraOptions.";
    };
    extraOptions = lib.mkOption {
      default = { };
      example = { };
      type = with lib.types; attrsOf anything;
      description = "Extra options to be applied to the gnome config";
    };
    extraDconf = lib.mkOption {
      default = { };
      example = { };
      type = with lib.types; attrsOf anything;
      description = "Extra options to be applied to the dconf config";
    };
  };

  config =
    let
      defaultExtensions = with pkgs.gnomeExtensions; [
        blur-my-shell
        dash-to-dock
        tray-icons-reloaded
      ];
    in
    lib.mkIf config.mods.gnome.enable (
      lib.optionalAttrs (options ? services.xserver.desktopManager.gnome) (
        {
          services.xserver = {
            enable = true;
            desktopManager.gnome.enable = true;
          };
        }
        // lib.mkIf config.mods.gnome.useDefaultOptions { environment.systemPackages = defaultExtensions; }
        // {
          services.xserver.desktopManager.gnome = config.mods.gnome.extraOptions;
        }
      )
      // lib.optionalAttrs (options ? dconf) (
        lib.mkIf config.mods.gnome.useDefaultOptions {
          dconf = {
            enable = true;
            settings = {
              "org/gnome/shell" = {
                disable-user-extensions = false;
                enabled-extensions = map (extension: extension.extensionUuid) defaultExtensions;
              };
              "org/gnome/desktop/interface" = {
                cursor-theme = config.mods.stylix.cursor.name;
                cursor-size = config.mods.stylix.cursor.size;
                color-scheme = "prefer-dark";
              };
            };
          };
        }
        // {
          dconf = config.mods.gnome.extraDconf;
        }
      )
    );
}
