{
  mkDashDefault,
  lib,
  config,
  options,
  ...
}: {
  options.mods = {
    bluetooth.enable = lib.mkOption {
      default = false;
      type = lib.types.bool;
      example = true;
      description = ''
        Enables bluetooth.
      '';
    };
  };

  config = lib.mkIf config.mods.bluetooth.enable (
    lib.optionalAttrs (options ? hardware.bluetooth) {
      hardware.bluetooth = {
        enable = mkDashDefault true;
        powerOnBoot = mkDashDefault true;
      };
    }
  );
}
