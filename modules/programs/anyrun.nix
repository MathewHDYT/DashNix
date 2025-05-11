{
  mkDashDefault,
  lib,
  config,
  pkgs,
  options,
  inputs,
  ...
}: {
  options.mods.anyrun = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = "Enables anyrun";
    };
    useDefaultConfig = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
      description = ''
        Use preconfigured anyrun config.
      '';
    };
    customConfig = lib.mkOption {
      default = {};
      example = {};
      type = with lib.types; attrsOf anything;
      description = ''
        Custom anyrun configuration.
        Will be merged with default configuration if enabled.
      '';
    };
    useDefaultCss = lib.mkOption {
      default = true;
      example = false;
      type = lib.types.bool;
      description = ''
        Use preconfigured anyrun css.
      '';
    };
    customCss = lib.mkOption {
      default = '''';
      example = ''
        #window {
          border-radius: none;
        }
      '';
      type = lib.types.lines;
      description = ''
        Custom anyrun css.
        Will be merged with default css if enabled.
      '';
    };
  };

  config = lib.mkIf config.mods.anyrun.enable (
    lib.optionalAttrs (options ? home.packages) {
      programs.anyrun = lib.mkForce {
        enable = true;
        config =
          if config.mods.anyrun.useDefaultConfig
          then
            lib.mkMerge
            [
              {
                plugins = [
                  inputs.anyrun.packages.${pkgs.system}.applications
                  inputs.anyrun.packages.${pkgs.system}.rink
                  inputs.anyrun.packages.${pkgs.system}.translate
                  inputs.anyrun.packages.${pkgs.system}.websearch
                ];
                hideIcons = mkDashDefault false;
                width = {
                  fraction = mkDashDefault 0.3;
                };
                y = {
                  fraction = mkDashDefault 0.5;
                };
                layer = mkDashDefault "overlay";
                hidePluginInfo = mkDashDefault true;
                closeOnClick = mkDashDefault true;
              }
              config.mods.anyrun.customConfig
            ]
          else config.mods.anyrun.customConfig;

        extraCss =
          if config.mods.anyrun.useDefaultCss
          then
            ''
              #window {
                border-radius: 10px;
                background-color: transparent;
              }

              box#main {
                border-radius: 10px;
              }

              list#main {
                border-radius: 10px;
                margin: 0px 10px 10px 10px;
              }

              list#plugin {
                border-radius: 10px;
              }

              list#match {
                border-radius: 10px;
              }

              entry#entry {
                border: 0;
                border-radius: 10px;
                margin: 10px 10px 0px 10px;
              }

              label#match-desc {
                font-size: 12px;
                border-radius: 10px;
              }

              label#match-title {
                font-size: 12px;
                border-radius: 10px;
              }

              label#plugin {
                font-size: 16px;
                border-radius: 10px;
              }

              * {
                border-radius: 10px;
              }
            ''
            + config.mods.anyrun.customCss
          else config.mods.anyrun.customCss;
      };
    }
  );
}
