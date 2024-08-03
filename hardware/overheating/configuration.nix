{
  imports = [
    ../../modules/conf.nix
  ];
  conf = {
    monitor = "eDP-1";
    scale = "2.0";
    hostname = "overheating";
    boot_params = [ "rtc_cmos.use_acpi_alarm=1" ];
    ironbar.modules = [
      { type = "upower"; class = "memory-usage"; }
    ];
    colorscheme = "catppuccin-mocha";
  };
  mods = {
    hyprland = {
      monitor = [
        # default
        "eDP-1,2944x1840@90,0x0,2"

        # all others
        ",highres,auto,1"
      ];
      extra_autostart = [ "hyprdock --server" ];
    };
    amdgpu.enable = true;
    kde_connect.enable = true;
    bluetooth.enable = true;
    acpid.enable = true;
    greetd = {
      resolution = "3440x1440@180";
    };
  };
}