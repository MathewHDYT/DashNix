{
  lib,
  dashNixAdditionalProps,
  config,
  options,
  pkgs,
  ...
}: let
  name = "librewolf";
in {
  imports = [
    (import ../../../lib/foxextensions.nix
      {inherit lib dashNixAdditionalProps pkgs name;})
  ];
  options.mods.browser.${name} = {
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
  config = lib.mkIf (config.mods.browser.librewolf.enable || config.mods.homePackages.browser == "librewolf") (
    lib.optionalAttrs (options ? home.packages) {
      programs.librewolf-dashnix = {
        enable = true;
        package =
          pkgs.wrapFirefox
          pkgs.librewolf-unwrapped
          {
            pname = "librewolf";
            extraPolicies =
              config.mods.browser.librewolf.configuration
              // {
                ExtensionSettings = builtins.foldl' (acc: ext: acc // ext) {} config.mods.browser.librewolf.extensions;
              };
          };
        profiles = builtins.listToAttrs config.mods.browser.librewolf.profiles;
      };
    }
  );
}
