{
  mkDashDefault,
  pkgs,
  ...
}: let
  layout = pkgs.writeText "enIntUmlaut" ''
    xkb_symbols "enIntUmlaut"
    {
      include "us(basic)"
      include "level3(ralt_switch)"
      key <AC01> { [ a, A, adiaeresis, Adiaeresis ] };
      key <AD09> { [ o, O, odiaeresis, Odiaeresis ] };
      key <AD07> { [ u, U, udiaeresis, Udiaeresis ] };
    };
  '';
in {
  environment.systemPackages = mkDashDefault [pkgs.xorg.xkbcomp];
  services.xserver.xkb.extraLayouts.enIntUmlaut = {
    description = "US layout with 'umlaut'";
    languages = ["eng"];
    symbolsFile = "${layout}";
  };
}
