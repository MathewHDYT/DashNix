{
  lib,
  config,
  pkgs,
  inputs,
  options,
  ...
}: let
  username = config.conf.username;
  base16 = pkgs.callPackage inputs.base16.lib {};
  scheme = base16.mkSchemeAttrs config.stylix.base16Scheme;
  ironbarDefaultConfig = {
    end = [
      {
        type = "sys_info";
        format = [" {memory_percent}"];
        interval.memory = 30;
        class = "memory-usage";
      }
      {
        type = "custom";
        bar = [
          {
            type = "button";
            class = "popup-button";
            label = "";
            on_click = "popup:toggle";
          }
        ];
        class = "popup-button-box";
        popup = [
          {
            type = "box";
            orientation = "vertical";
            class = "audio-box";
            widgets = [
              {
                type = "box";
                orientation = "horizontal";
                widgets = [
                  {
                    type = "button";
                    class = "audio-button";
                    label = "";
                    on_click = lib.mkIf config.mods.scripts.audioControl "!audioControl bluetooth";
                  }
                  {
                    type = "button";
                    class = "audio-button";
                    label = "󰋋";
                    on_click = lib.mkIf config.mods.scripts.audioControl "!audioControl internal";
                  }
                ];
                class = "audio-button-box";
              }
              {
                type = "label";
                label = "Output";
              }
              {
                type = "slider";
                class = "audio-slider";
                step = 1.0;
                length = 200;
                value = "pactl get-sink-volume @DEFAULT_SINK@ | awk -F'/' '{ print $2 }' | tr -d ' %'";
                on_change = "!pactl set-sink-volume @DEFAULT_SINK@ $0%";
              }
              {
                type = "label";
                label = "Input";
              }
              {
                type = "slider";
                class = "audio-slider";
                step = 1.0;
                length = 200;
                value = "pactl get-source-volume @DEFAULT_SOURCE@ | awk -F'/' '{ print $2 }' | tr -d ' %'";
                on_change = "!pactl set-source-volume @DEFAULT_SOURCE@ $0%";
              }
            ];
          }
        ];
      }
      {
        type = "custom";
        bar = [
          {
            type = "button";
            class = "popup-button";
            label = "";
            on_click = "!oxidash --css /home/${username}/gits/oxidash/style.css";
          }
        ];
        class = "popup-button-box";
      }
      {
        type = "clock";
        format = "%I:%M";
        format_popup = "%I:%M:%S";
        locale = "en_US";
      }
      {type = "tray";}
    ];
    position = "top";
    height = 10;
    anchor_to_edges = true;
    start = [
      {
        type = "workspaces";
        all_monitors = true;
      }
    ];
    center = [
      {
        type = "focused";
        show_icon = true;
        show_title = true;
        icon_size = 20;
        truncate = "end";
      }
    ];
  };
  monitorConfig =
    if config.mods.hypr.hyprland.enable
    then {monitors.${config.mods.hypr.hyprland.defaultMonitor} = ironbarDefaultConfig;}
    else ironbarDefaultConfig;
in {
  options.mods = {
    ironbar = {
      enable = lib.mkOption {
        default = false;
        example = true;
        type = lib.types.bool;
        description = "Enables ironbar";
      };
      useDefaultConfig = lib.mkOption {
        default = true;
        example = false;
        type = lib.types.bool;
        description = ''
          Use preconfigured ironbar config.
        '';
      };
      customConfig = lib.mkOption {
        default = {};
        example = {};
        type = with lib.types; attrsOf anything;
        description = ''
          Custom ironbar configuration.
          Will be merged with default configuration if enabled.
        '';
      };
      useDefaultCss = lib.mkOption {
        default = true;
        example = false;
        type = lib.types.bool;
        description = ''
          Use preconfigured ironbar css.
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
          Custom ironbar css.
          Will be merged with default css if enabled.
        '';
      };
    };
  };
  config = lib.mkIf (config.mods.ironbar.enable || config.mods.hypr.hyprland.useIronbar) (
    lib.optionalAttrs (options ? programs.ironbar) {
      programs.ironbar = {
        enable = true;
        style =
          if config.mods.ironbar.useDefaultCss
          then
            /*
            css
            */
            ''
              @import url("/home/${username}/.config/gtk-3.0/gtk.css");

              * {
                color: #${scheme.base0D};
                padding: 0px;
                margin: 0px;
              }

              .background {
                background-color: rgba(0, 0, 0, 0);
              }

              .workspaces {
                margin: 2px 0px 0px 5px;
                border-radius: 10px;
                background-color: #${scheme.base00};
                padding: 2px 5px 2px 5px;
              }

              .workspaces .item {
                margin: 0px 3px 0px 3px;
                font-size: 13px;
                border-radius: 100%;
                padding: 0px 2px 0px 3px;
                background-color: rgba(0, 0, 0, 0);
              }

              .workspaces .item:hover {
                background-color: #${scheme.base02};
              }

              .workspaces .item.focused {
                background-color: #${scheme.base02};
              }

              .audio-box {
                padding: 2em;
                background-color: #${scheme.base00};
                border-radius: 5px;
              }

              .audio-slider {
                padding: 5px;
                margin: 5px;
              }

              .audio-button {
                padding: 5px 10px 5px 10px;
                margin: 0px 1em 20px 1em;
                border-radius: 100%;
                font-size: 17px;
              }

              .audio-button-box {
                padding: 0px 2.5em 0px 2.5em;
              }

              .focused {
                padding: 0px 5px 0px 5px;
                background-color: #${scheme.base00};
                font-size: 17px;
                border-radius: 10px;
              }

              #bar #end {
                margin: 0px 5px 0px 0px;
                padding: 0px 5px 0px 5px;
                background-color: #${scheme.base00};
                border-radius: 10px;
              }

              .popup-button {
                padding: 0px 5px 0px 3px;
                margin: 0em 3px;
                border-radius: 100%;
                font-size: 13px;
                background-color: #${scheme.base00};
              }

              .popup-button-box {
                padding: 2px 0px 2px 0px;
              }

              .clock {
                padding: 0px 5px 0px 5px;
                font-size: 17px;
                background-color: #${scheme.base00};
              }

              .clock:hover {
                background-color: #${scheme.base02};
              }

              .custom button {
                background-color: #${scheme.base00};
              }

              .custom button:hover {
                background-color: #${scheme.base02};
              }

              .memory-usage {
                font-size: 15px;
                margin: 0px 5px 0px 0px;
              }

              .memory-usage:hover {
                background-color: #${scheme.base02};
              }

              .popup-clock {
                background-color: #${scheme.base00};
                border-radius: 5px;
                padding: 2px 8px 10px 8px;
              }

              .popup-clock .calendar-clock {
                font-size: 2.5em;
                padding-bottom: 0.1em;
              }

              .popup-clock .calendar {
                border-radius: 5px;
                font-size: 1.05em;
              }

              .popup-clock .calendar:selected {
                background-color: #${scheme.base02};
              }
            ''
            + config.mods.ironbar.customCss
          else config.mods.ironbar.customCss;
        features = [
          #"another_feature"
        ];
        config =
          if config.mods.ironbar.useDefaultConfig
          then
            lib.mkMerge
            [
              monitorConfig
              config.mods.ironbar.customConfig
            ]
          else config.mods.ironbar.customConfig;
      };
    }
  );
}
