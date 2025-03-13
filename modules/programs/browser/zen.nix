{
  lib,
  config,
  options,
  inputs,
  pkgs,
  ...
}: {
  options.mods.browser.zen = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = "Enables the zen browser";
    };
    configuration = lib.mkOption {
      default = {
        EnableTrackingProtection = {
          Value = true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
        };
        DisablePocket = true;
        DisplayBookmarksToolbar = "never";
        DisplayMenuBar = "default-off";
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = true;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
      example = {};
      type = with lib.types; attrsOf anything;
      description = "Zen policy configuration. See https://mozilla.github.io/policy-templates/ for more information.";
    };
    profiles = lib.mkOption {
      default = let
        extensions = [
          pkgs.nur.repos.rycee.firefox-addons.darkreader
          pkgs.nur.repos.rycee.firefox-addons.ublock-origin
          pkgs.nur.repos.rycee.firefox-addons.ghostery
          pkgs.nur.repos.rycee.firefox-addons.canvasblocker
          pkgs.nur.repos.rycee.firefox-addons.i-dont-care-about-cookies
          pkgs.nur.repos.rycee.firefox-addons.keepassxc-browser
          pkgs.nur.repos.rycee.firefox-addons.vimium
          pkgs.nur.repos.rycee.firefox-addons.react-devtools
          pkgs.nur.repos.rycee.firefox-addons.reduxdevtools
          pkgs.nur.repos.rycee.firefox-addons.user-agent-string-switcher
          pkgs.nur.repos.rycee.firefox-addons.private-relay
        ];
      in [
        {
          name = "${config.conf.username}";
          value = {
            settings = {
              zen.view.compact.hide-tabbar = false;
              zen.view.compact.hide-toolbar = true;
              zen.view.sidebar-expanded = false;
              zen.view.use-single-toolbar = false;
              zen.view.welcome-screen.seen = true;
              zen.theme.accent-color = "#b4bbff";
            };
            extensions.packages = extensions;
            isDefault = true;
            id = 0;
          };
        }
        {
          name = "special";
          value = {
            settings = {
              zen.view.compact.hide-tabbar = false;
              zen.view.compact.hide-toolbar = true;
              zen.view.sidebar-expanded = false;
              zen.view.use-single-toolbar = false;
              zen.view.welcome-screen.seen = true;
              zen.theme.accent-color = "#b4bbff";
            };
            extensions.packages = extensions;
            isDefault = false;
            id = 1;
          };
        }
      ];
      example = [
        {
          name = "custom";
          value = {
            isDefault = true;
            id = 0;
            extensions.packages = [pkgs.nur.repos.rycee.firefox-addons.darkreader];
          };
        }
      ];
      type = with lib.types; listOf (attrsOf anything);
      description = "Zen profiles";
    };
  };
  config = lib.mkIf config.mods.browser.zen.enable (
    lib.optionalAttrs (options ? home.packages) {
      programs.zen-browser = {
        enable = true;
        package =
          pkgs.wrapFirefox
          (inputs.zen-browser.packages.${pkgs.system}.default.overrideAttrs (prevAttrs: {
            passthru =
              prevAttrs.passthru
              or {}
              // {
                applicationName = "Zen Browser";
                binaryName = "zen";

                ffmpegSupport = true;
                gssSupport = true;
                gtk3 = pkgs.gtk3;
              };
          }))
          {
            icon = "zen-beta";
            wmClass = "zen";
            hasMozSystemDirPatch = false;
          };
        policies = config.mods.browser.zen.configuration;
        profiles = builtins.listToAttrs config.mods.browser.zen.profiles;
      };
    }
  );
}
