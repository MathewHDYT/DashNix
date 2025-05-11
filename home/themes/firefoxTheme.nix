# css from https://github.com/catppuccin/zen-browser/tree/main/themes
{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  # at time of using this here, stylix might not be evaluated yet
  # hence ensure it is by using base16 mkSchemeAttrs
  base16 = pkgs.callPackage inputs.base16.lib {};
  scheme = base16.mkSchemeAttrs config.stylix.base16Scheme;
  userChrome =
    /*
    css
    */
    ''
      /* Catppuccin Mocha Blue userContent.css*/

      @media (prefers-color-scheme: dark) {

        /* Common variables affecting all pages */
        @-moz-document url-prefix("about:") {
          :root {
            --in-content-page-color: #${scheme.base05} !important;
            --color-accent-primary: #${scheme.base0D} !important;
            --color-accent-primary-hover: rgb(163, 197, 251) !important; // TODO
            --color-accent-primary-active: rgb(138, 153, 250) !important; // TODO
            background-color: #${scheme.base00} !important;
            --in-content-page-background: #${scheme.base00} !important;
          }

        }

        /* Variables and styles specific to about:newtab and about:home */
        @-moz-document url("about:newtab"), url("about:home") {

          :root {
            --newtab-background-color: #${scheme.base00} !important;
            --newtab-background-color-secondary: #${scheme.base02} !important;
            --newtab-element-hover-color: #${scheme.base02} !important;
            --newtab-text-primary-color: #${scheme.base05} !important;
            --newtab-wordmark-color: #${scheme.base05} !important;
            --newtab-primary-action-background: #${scheme.base0D} !important;
          }

          .icon {
            color: #${scheme.base0D} !important;
          }

          .search-wrapper .logo-and-wordmark .logo {
            //background: url("zen-logo-mocha.svg"), url("https://raw.githubusercontent.com/IAmJafeth/zen-browser/main/themes/Mocha/Blue/zen-logo-mocha.svg") no-repeat center !important; // TODO
            display: inline-block !important;
            height: 82px !important;
            width: 82px !important;
            background-size: 82px !important;
          }

          @media (max-width: 609px) {
            .search-wrapper .logo-and-wordmark .logo {
              background-size: 64px !important;
              height: 64px !important;
              width: 64px !important;
            }
          }

          .card-outer:is(:hover, :focus, .active):not(.placeholder) .card-title {
            color: #${scheme.base0D} !important;
          }

          .top-site-outer .search-topsite {
            background-color: #${scheme.base0D} !important;
          }

          .compact-cards .card-outer .card-context .card-context-icon.icon-download {
            fill: #${scheme.base0B} !important;
          }
        }

        /* Variables and styles specific to about:preferences */
        @-moz-document url-prefix("about:preferences") {
          :root {
            --zen-colors-tertiary: #${scheme.base01} !important;
            --in-content-text-color: #${scheme.base05} !important;
            --link-color: #${scheme.base0D} !important;
            --link-color-hover: rgb(163, 197, 251) !important; // TODO
            --zen-colors-primary: #${scheme.base02} !important;
            --in-content-box-background: #${scheme.base02} !important;
            --zen-primary-color: #${scheme.base0D} !important;
          }

          groupbox , moz-card{
            background: #${scheme.base00} !important;
          }

          button,
          groupbox menulist {
            background: #${scheme.base02} !important;
            color: #${scheme.base05} !important;
          }

          .main-content {
            background-color: #${scheme.base01} !important;
          }

          .identity-color-blue {
            --identity-tab-color: #8aadf4 !important; // TODO
            --identity-icon-color: #8aadf4 !important; // TODO
          }

          .identity-color-turquoise {
            --identity-tab-color: #8bd5ca !important; // TODO
            --identity-icon-color: #8bd5ca !important; // TODO
          }

          .identity-color-green {
            --identity-tab-color: #${scheme.base0B} !important;
            --identity-icon-color: #${scheme.base0B} !important;
          }

          .identity-color-yellow {
            --identity-tab-color: #eed49f !important; // TODO
            --identity-icon-color: #eed49f !important; // TODO
          }

          .identity-color-orange {
            --identity-tab-color: #f5a97f !important; // TODO
            --identity-icon-color: #f5a97f !important; // TODO
          }

          .identity-color-red {
            --identity-tab-color: #ed8796 !important; // TODO
            --identity-icon-color: #ed8796 !important; // TODO
          }

          .identity-color-pink {
            --identity-tab-color: #f5bde6 !important; // TODO
            --identity-icon-color: #f5bde6 !important; // TODO
          }

          .identity-color-purple {
            --identity-tab-color: #c6a0f6 !important; // TODO
            --identity-icon-color: #c6a0f6 !important; // TODO
          }
        }

        /* Variables and styles specific to about:addons */
        @-moz-document url-prefix("about:addons") {
          :root {
            --zen-dark-color-mix-base: #${scheme.base01} !important;
            --background-color-box: #${scheme.base00} !important;
          }
        }

        /* Variables and styles specific to about:protections */
        @-moz-document url-prefix("about:protections") {
          :root {
            --zen-primary-color: #${scheme.base00} !important;
            --social-color: #${scheme.base0E} !important;
            --coockie-color: #${scheme.base08} !important;
            --fingerprinter-color: #${scheme.base0A} !important;
            --cryptominer-color: #${scheme.base07} !important;
            --tracker-color: #${scheme.base0B} !important;
            --in-content-primary-button-background-hover: rgb(81, 83, 05) !important;
            --in-content-primary-button-text-color-hover: #${scheme.base05} !important;
            --in-content-primary-button-background: #${scheme.base03} !important;
            --in-content-primary-button-text-color: #${scheme.base05} !important;
          }


          .card {
            background-color: #${scheme.base02} !important;
          }
        }
      }
    '';
  userContent =
    /*
    css
    */
    ''
      /* Catppuccin Mocha Blue userChrome.css*/
      @media (prefers-color-scheme: dark) {

        :root {
          --zen-colors-primary: #${scheme.base02} !important;
          --zen-primary-color: #${scheme.base0D} !important;
          --zen-colors-secondary: #${scheme.base02} !important;
          --zen-colors-tertiary: #${scheme.base01} !important;
          --zen-colors-border: #${scheme.base0D} !important;
          --toolbarbutton-icon-fill: #${scheme.base0D} !important;
          --lwt-text-color: #${scheme.base05} !important;
          --toolbar-field-color: #${scheme.base05} !important;
          --tab-selected-textcolor: rgb(171, 197, 247) !important; // TODO
          --toolbar-field-focus-color: #${scheme.base05} !important;
          --toolbar-color: #${scheme.base05} !important;
          --newtab-text-primary-color: #${scheme.base05} !important;
          --arrowpanel-color: #${scheme.base05} !important;
          --arrowpanel-background: #${scheme.base00} !important;
          --sidebar-text-color: #${scheme.base05} !important;
          --lwt-sidebar-text-color: #${scheme.base05} !important;
          --lwt-sidebar-background-color: #${scheme.base01} !important; //TODO 11111b !important;
          --toolbar-bgcolor: #${scheme.base02} !important;
          --newtab-background-color: #${scheme.base00} !important;
          --zen-themed-toolbar-bg: #${scheme.base01} !important;
          --zen-main-browser-background: #${scheme.base01} !important;
        }

        #permissions-granted-icon{
          color: #${scheme.base01} !important;
        }

        .sidebar-placesTree {
          background-color: #${scheme.base00} !important;
        }

        #zen-workspaces-button {
          background-color: #${scheme.base00} !important;
        }

        #TabsToolbar {
          background-color: #${scheme.base01} !important;
        }

        #urlbar-background {
          background-color: #${scheme.base00} !important;
        }

        .content-shortcuts {
          background-color: #${scheme.base00} !important;
          border-color: #${scheme.base0D} !important;
        }

        .urlbarView-url {
          color: #${scheme.base0D} !important;
        }

        #zenEditBookmarkPanelFaviconContainer {
          background: #${scheme.base01} !important;
        }

        toolbar .toolbarbutton-1 {
          &:not([disabled]) {
            &:is([open], [checked]) > :is(.toolbarbutton-icon, .toolbarbutton-text, .toolbarbutton-badge-stack){
              fill: #${scheme.base01};
            }
          }
        }

        .identity-color-blue {
          --identity-tab-color: #${scheme.base0D} !important;
          --identity-icon-color: #${scheme.base0D} !important;
        }

        .identity-color-turquoise {
          --identity-tab-color: #${scheme.base0C} !important;
          --identity-icon-color: #${scheme.base0C} !important;
        }

        .identity-color-green {
          --identity-tab-color: #${scheme.base0B} !important;
          --identity-icon-color: #${scheme.base0B} !important;
        }

        .identity-color-yellow {
          --identity-tab-color: #${scheme.base0A} !important;
          --identity-icon-color: #${scheme.base0A} !important;
        }

        .identity-color-orange {
          --identity-tab-color: #${scheme.base09} !important;
          --identity-icon-color: #${scheme.base09} !important;
        }

        .identity-color-red {
          --identity-tab-color: #${scheme.base08} !important;
          --identity-icon-color: #${scheme.base08} !important;
        }

        .identity-color-pink {
          --identity-tab-color: #${scheme.base0F} !important;
          --identity-icon-color: #${scheme.base0F} !important; // TODO f5c2e7
        }

        .identity-color-purple {
          --identity-tab-color: #${scheme.base0E} !important;
          --identity-icon-color: #${scheme.base0E} !important;
        }
      }
    '';
  browsername = config.mods.homePackages.browser;
  profiles =
    if config.mods.homePackages.browser == "firefox"
    then config.mods.browser.firefox.profiles
    else if config.mods.homePackages.browser == "zen"
    then config.mods.browser.zen.profiles
    else if config.mods.homePackages.browser == "librewolf"
    then [
      {
        name = "default";
        value = {};
      }
    ]
    else [];
  profileNamesFn =
    builtins.catAttrs "name";
  chromesFn = builtins.map (
    name:
      if (builtins.isString browsername)
      then {
        ".${browsername}/${name}/chrome/userContent.css" = {
          text = userChrome;
        };

        ".${browsername}/${name}/chrome/userChrome.css" = {
          text = userContent;
        };
      }
      else {}
  );
  moduleFn = lib.lists.foldr (attr1: attr2: attr1 // attr2) {};
  mkFirefoxTheme = (
    profiles:
      profiles
      |> profileNamesFn
      |> chromesFn
      |> moduleFn
  );
in {home.file = mkFirefoxTheme profiles;}
