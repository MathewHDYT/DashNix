{
  lib,
  config,
  options,
  system,
  inputs,
  ...
}:
{
  options.mods.browser.zen = {
    enable = lib.mkOption {
      default = false;
      example = true;
      type = lib.types.bool;
      description = "Enables the zen browser";
    };
    optimization = lib.mkOption {
      default = "specific";
      example = "generic";
      type =
        with lib.types;
        (enum [
          "specific"
          "generic"
        ]);
      description = "Enables the zen browser";
    };
    # TODO configure zen
  };
  config = lib.mkIf config.mods.browser.zen.enable (
    lib.optionalAttrs (options ? home.packages) {
      home.packages = [ inputs.zen-browser.packages."${system}".${config.mods.browser.zen.optimization} ];
    }
  );
}
