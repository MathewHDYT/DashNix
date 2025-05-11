{
  mkDashDefault,
  lib,
  config,
  options,
  pkgs,
  ...
}: {
  options.mods.containers = {
    variant = lib.mkOption {
      default = "";
      example = "podman";
      type = lib.types.enum [
        ""
        "podman"
        "docker"
      ];
      description = "Enables and configures a containerization solution: podman/docker";
    };
    podmanPackages = lib.mkOption {
      default = with pkgs; [
        podman-tui
        podman-compose
      ];
      example = [];
      type = with lib.types; listOf package;
      description = "Podman packages";
    };
    dockerPackages = lib.mkOption {
      default = with pkgs; [
        docker-compose
      ];
      example = [];
      type = with lib.types; listOf package;
      description = "Docker packages";
    };
    combinedPackages = lib.mkOption {
      default = with pkgs; [
        dive
      ];
      example = [];
      type = with lib.types; listOf package;
      description = "Container packages";
    };
  };
  config = (
    lib.optionalAttrs (options ? environment.systemPackages) {
      environment.systemPackages =
        (lib.lists.optionals (
            config.mods.containers.variant == "podman"
          )
          config.mods.containers.podmanPackages)
        ++ (lib.lists.optionals (
            config.mods.containers.variant == "docker"
          )
          config.mods.containers.dockerPackages)
        ++ (lib.lists.optionals (
            config.mods.containers.variant == "podman" || config.mods.containers.variant == "docker"
          )
          config.mods.containers.combinedPackages);
      virtualisation =
        if (config.mods.containers.variant == "podman")
        then {
          containers.enable = true;
          podman = {
            enable = true;
            dockerCompat = mkDashDefault true;
            defaultNetwork.settings.dns_enabled = mkDashDefault true;
          };
        }
        else if (config.mods.containers.variant == "docker")
        then {
          containers.enable = true;
          docker = {
            enable = true;
          };
        }
        else {};
    }
  );
}
