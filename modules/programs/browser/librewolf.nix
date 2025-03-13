{
  lib,
  config,
  options,
  pkgs,
  ...
}: {
  options.mods.browser.librewolf = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = "Enables the librwolf browser";
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
      description = "Librewolf policy configuration. See https://mozilla.github.io/policy-templates/ for more information.";
    };
    profiles = lib.mkOption {
      default = [
        {
          name = "${config.conf.username}";
          value = {
            isDefault = true;
            id = 0;
          };
        }
        {
          name = "special";
          value = {
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
      description = "Librewolf profiles";
    };
  };
  config = lib.mkIf config.mods.browser.librewolf.enable (
    lib.optionalAttrs (options ? home.packages) {
      programs.librewolf-dashnix = {
        enable = true;
        package = pkgs.librewolf;
        policies = config.mods.browser.librewolf.configuration;
        profiles = builtins.listToAttrs config.mods.browser.librewolf.profiles;
      };
    }
  );
}
