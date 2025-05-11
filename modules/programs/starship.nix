{
  mkDashDefault,
  lib,
  config,
  options,
  pkgs,
  inputs,
  ...
}: {
  options.mods = {
    starship = {
      enable = lib.mkOption {
        default = true;
        example = false;
        type = lib.types.bool;
        description = ''
          Enables starship prompt
        '';
      };
      useDefaultPrompt = lib.mkOption {
        default = true;
        example = false;
        type = lib.types.bool;
        description = ''
          Enables preconfigured prompt
        '';
      };
      customPrompt = lib.mkOption {
        default = {};
        example = {};
        type = with lib.types; attrsOf anything;
        description = ''
          Custom configuration for prompt.
          Will be merged with preconfigured prompt if that is used.
        '';
      };
    };
  };

  # environment.systemPackages needed in order to configure systemwide
  config = lib.mkIf config.mods.starship.enable (
    lib.optionalAttrs (options ? environment.systemPackages) {
      programs.starship = let
        base16 = pkgs.callPackage inputs.base16.lib {};
        scheme = base16.mkSchemeAttrs config.stylix.base16Scheme;
        code_format = "[](bg:prev_bg fg:#5256c3)[ $symbol ($version)](bg:#5256c3)";
      in {
        enable = true;
        interactiveOnly = mkDashDefault true;
        presets = lib.mkIf config.mods.starship.useDefaultPrompt ["pastel-powerline"];
        settings =
          lib.mkIf config.mods.starship.useDefaultPrompt {
            # derived from https://starship.rs/presets/pastel-powerline
            format = "$username$directory$git_branch$git_status$git_metrics[ ](bg:none fg:prev_bg)";
            right_format = "$c$elixir$elm$golang$gradle$haskell$java$julia$nodejs$nim$rust$scala$python$ocaml$opa$perl$zig$dart$dotnet$nix_shell$shell$solidity[](bg:prev_bg fg:#3465A4)$time$os";
            username = {
              show_always = false;
              style_user = "bg:#5277C3 fg:#${scheme.base05}";
              style_root = "bg:#5277C3 fg:#${scheme.base05}";
              format = "[ $user ]($style)[](bg:#3465A4 fg:#5277C3)";
              disabled = false;
            };
            os = {
              symbols = {
                NixOS = "  ";
              };
              style = "bg:#3465A4 fg:#${scheme.base05}";
              disabled = false;
            };
            directory = {
              style = "bg:#3465A4 fg:#${scheme.base05}";
              format = "[ $path ]($style)";
              truncation_length = 3;
              truncation_symbol = "…/";
            };
            git_branch = {
              always_show_remote = true;
              symbol = "";
              style = "bg:#5256c3 fg:#${scheme.base05}";
              format = "[ ](bg:#5256c3 fg:prev_bg)[$symbol ($remote_name )$branch ]($style)";
            };
            git_status = {
              staged = "+\${count} (fg:#C4A000)";
              ahead = "⇡\${count} (fg:#C4A000)";
              diverged = "⇕⇡\${count} (fg:#C4A000)";
              behind = "⇣\${count} (fg:#C4A000)";
              stashed = " ";
              untracked = "?\${count} (fg:#C4A000)";
              modified = "!\${count} (fg:#C4A000)";
              deleted = "✘\${count} (fg:#C4A000)";
              conflicted = "=\${count} (fg:#C4A000)";
              renamed = "»\${count} (fg:#C4A000)";
              style = "bg:#5256c3 fg:fg:#C4A000";
              format = "[$all_status$ahead_behind]($style)";
            };
            git_metrics = {
              disabled = false;
              format = "([| ](bg:#5256c3)[+$added]($added_style bg:#5256c3)[ -$deleted]($deleted_style bg:#5256c3))";
            };
            c = {
              format = code_format;
            };
            elixir = {
              format = code_format;
            };
            elm = {
              format = code_format;
            };
            golang = {
              format = code_format;
            };
            gradle = {
              format = code_format;
            };
            haskell = {
              format = code_format;
            };
            java = {
              format = code_format;
            };
            julia = {
              format = code_format;
            };
            nodejs = {
              format = code_format;
            };
            nim = {
              format = code_format;
            };
            nix_shell = {
              symbol = "";
              format = code_format;
            };
            rust = {
              format = code_format;
            };
            scala = {
              format = code_format;
            };
            typst = {
              format = code_format;
            };
            python = {
              format = code_format;
            };
            ocaml = {
              format = code_format;
            };
            opa = {
              format = code_format;
            };
            perl = {
              format = code_format;
            };
            zig = {
              format = code_format;
            };
            dart = {
              format = code_format;
            };
            dotnet = {
              format = code_format;
            };
            time = {
              disabled = false;
              time_format = "%R"; # Hour:Minute Format
              style = "bg:#3465A4 fg:#${scheme.base05}";
              format = "[ $time ]($style)";
            };
          }
          // config.mods.starship.customPrompt;
      };
    }
  );
}
