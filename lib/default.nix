{
  inputs,
  pkgs,
  self,
  stable,
  lib,
  ...
}:
{
  /*
    *
    # build_systems

    Builds system given a list of system names which are placed within your hosts/ directory. Note that each system has its own directory in hosts/ as well.

    A minimal configuration requires the file configuration.nix within each system directory, this will be the base config that is used across both NisOS and home-manager, specific optional files can also be added, hardware.nix for NisOS configuration and home.nix for home-manager configuration.

    The second parameter is the root of your configuration, which should be ./. in most cases.

    `root`

    : the root path of your configuration

    # Example usage
    :::{.example}
    ```nix
    nixosConfigurations = build_systems { root = ./.; };
    ```
    :::
  */
  # let
  #   paths = builtins.readDir ;
  #   names = lib.lists.remove "default" (
  #     map (name: lib.strings.removeSuffix ".nix" name) (lib.attrsets.mapAttrsToList (name: _: name) paths)
  #   );

  # in
  build_systems =
    {
      root,
      additionalMods ? {
        nixos = [ ];
        home = [ ];
      },
      mods ? {
        nixos = [
          inputs.home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          ../base
          ../home
          ../modules
        ];
        home = [
          inputs.anyrun.homeManagerModules.default
          inputs.ironbar.homeManagerModules.default
          inputs.oxicalc.homeManagerModules.default
          inputs.oxishut.homeManagerModules.default
          inputs.oxinoti.homeManagerModules.default
          inputs.oxidash.homeManagerModules.default
          inputs.oxipaste.homeManagerModules.default
          inputs.hyprdock.homeManagerModules.default
          inputs.hyprland.homeManagerModules.default
          inputs.reset.homeManagerModules.default
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
          inputs.sops-nix.homeManagerModules.sops
          inputs.dashvim.homeManagerModules.dashvim
          ../modules
        ];
      },
      additionalInputs ? { },
      overridePkgs ? false,
      ...
    }:
    builtins.listToAttrs (
      map
        (name: {
          name = name;
          value =
            let
              mod = root + /hosts/${name}/configuration.nix;
              additionalNixosConfig = root + /hosts/${name}/hardware.nix;
              additionalHomeConfig = root + /hosts/${name}/home.nix;
            in
            inputs.nixpkgs.lib.nixosSystem {
              specialArgs = {
                inherit
                  self
                  inputs
                  mod
                  additionalHomeConfig
                  root
                  ;
                pkgs = if overridePkgs then pkgs else stable;
                alternativePkgs = if overridePkgs then stable else pkgs;
                hostName = name;
                homeMods = mods.home;
                additionalHomeMods = additionalMods.home;
                additionalInputs = additionalInputs;
              };
              modules =
                [ mod ]
                ++ mods.nixos
                ++ additionalMods.nixos
                ++ inputs.nixpkgs.lib.optional (builtins.pathExists additionalNixosConfig) additionalNixosConfig
                ++ inputs.nixpkgs.lib.optional (builtins.pathExists mod) mod;
            };
        })
        (
          lib.lists.remove "" (
            lib.attrsets.mapAttrsToList (name: fType: if fType == "directory" then name else "") (
              builtins.readDir (root + /hosts)
            )
          )
        )
    );

  buildIso = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      inherit self inputs pkgs;
    };
    modules = [ ../iso/configuration.nix ];
  };
}
