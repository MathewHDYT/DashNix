{
  lib,
  dashNixAdditionalProps,
  pkgs,
  name,
  ...
}: let
  mkExtension = id: install_url: {
    ${id} = {
      inherit install_url;
      installation_mode = "normal_installed";
    };
  };
in {
  options.mods.browser.${name}.extensions = lib.mkOption {
    default = [
      (mkExtension "uBlock0@raymondhill.net" "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi")
      (mkExtension "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}" "https://addons.mozilla.org/firefox/downloads/latest/user-agent-string-switcher/latest.xpi")
      (mkExtension "{d7742d87-e61d-4b78-b8a1-b469842139fa}" "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi")
      (mkExtension "firefox@ghostery.com" "https://addons.mozilla.org/firefox/downloads/latest/ghostery/latest.xpi")
      (mkExtension "CanvasBlocker@kkapsner.de" "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi")
      (mkExtension "jid1-KKzOGWgsW3Ao4Q@jetpack" "https://addons.mozilla.org/firefox/downloads/latest/i-dont-care-about-cookies/latest.xpi")
      (mkExtension "keepassxc-browser@keepassxc.org" "https://addons.mozilla.org/firefox/downloads/latest/keepassxc-browser/latest.xpi")
      (mkExtension "@react-devtools" "https://addons.mozilla.org/firefox/downloads/latest/react-devtools/latest.xpi")
      (mkExtension "extension@redux.devtools" "https://addons.mozilla.org/firefox/downloads/latest/reduxdevtools/latest.xpi")
      (mkExtension "private-relay@firefox.com" "https://addons.mozilla.org/firefox/downloads/latest/private-relay/latest.xpi")
      (mkExtension "addon@darkreader.org" "file://${pkgs.callPackage ../patches/darkreader.nix {inherit lib dashNixAdditionalProps;}}/latest.xpi")
    ];
    example = [
      {
        "78272b6fa58f4a1abaac99321d503a20@proton.me" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/proton-pass/latest.xpi";
          installation_mode = "normal_installed";
        };
      }
    ];
    type = with lib.types; listOf anything;
    description = ''
      List of extensions via attrsets:
      ```nix
      # id
      # figure out the id via:
      # nix run github:tupakkatapa/mozid -- 'https://addons.mozilla.org/en/firefox/addon/ublock-origin'
      "uBlock0@raymondhill.net" = {
        # install url
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        # method https://mozilla.github.io/policy-templates/#extensionsettings
        installation_mode = "force_installed";
      };
      ```
    '';
  };
}
