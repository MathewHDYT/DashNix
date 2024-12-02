{
  description = "DashNix";

  inputs = {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-unstable";
    stable.url = "github:NixOs/nixpkgs/nixos-24.11";

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    Hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    nur.url = "github:nix-community/nur";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";

    ironbar = {
      url = "github:JakeStanger/ironbar?ref=3a1c60442382f970cdb7669814b6ef3594d9f048";
    };

    zen-browser.url = "github:fufexan/zen-browser-flake";

    stylix.url = "github:danth/stylix";
    base16.url = "github:SenchoPens/base16.nix";

    anyrun.url = "github:Kirottu/anyrun";
    oxicalc.url = "github:DashieTM/OxiCalc";
    oxishut.url = "github:DashieTM/OxiShut";
    oxinoti.url = "github:DashieTM/OxiNoti";
    oxidash.url = "github:DashieTM/OxiDash";
    oxipaste.url = "github:DashieTM/OxiPaste";
    hyprdock.url = "github:DashieTM/hyprdock";
    reset.url = "github:Xetibo/ReSet";
    reset-plugins.url = "github:Xetibo/ReSet-Plugins";

    dashvim = {
      url = "github:DashieTM/DashVim";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.base16.follows = "base16";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      stable = import inputs.stable {
        system = "x86_64-linux";
        config = {
          allowUnfree = true;
        };
      };
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        overlays = [ inputs.nur.overlay ];
        config = {
          allowUnsupportedSystem = true;
          permittedInsecurePackages = [
            "olm-3.2.16"
            # well done dotnet...
            # this is just for omnisharp
            "dotnet-core-combined"
            "dotnet-sdk-6.0.428"
            "dotnet-sdk-wrapped-6.0.428"
            "dotnet-sdk-6.0.136"
            "dotnet-sdk-wrapped-6.0.136"
            "dotnet-sdk-7.0.120"
            "dotnet-sdk-wrapped-7.0.120"
            "dotnet-sdk-7.0.410"
            "dotnet-sdk-wrapped-7.0.410"
          ];
          allowUnfree = true;
        };
      };
    in
    rec {
      dashNixLib = import ./lib {
        inherit self inputs pkgs;
        lib = inputs.nixpkgs.lib;
      };
      docs = import ./docs {
        inherit inputs pkgs;
        lib = inputs.nixpkgs.lib;
        build_systems = dashNixLib.build_systems;
      };
      dashNixInputs = inputs;
      stablePkgs = stable;
      unstablePkgs = pkgs;
      modules = ./modules;
      iso = dashNixLib.buildIso.config.system.build.isoImage;
    };

  nixConfig = {
    builders-use-substitutes = true;

    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://anyrun.cachix.org"
      "https://cache.garnix.io"
    ];

    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };
}
