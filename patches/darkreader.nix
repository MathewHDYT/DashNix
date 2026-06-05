# credits to Voronind for darkreader config https://github.com/voronind-com/nix/blob/main/home/program/firefox/default.nix
{
  lib,
  buildNpmPackage,
  esbuild,
  fetchFromGitHub,
  ...
}:
buildNpmPackage rec {
  version = "4.9.127";
  pname = "dark-reader";
  npmDepsHash = "sha256-Rv14DNwPBzhhR9+drkbTUfCcd2dCRoAcYPd9gANyDbY=";
  npmDepsFetcherVersion = 2;
  env.ESBUILD_BINARY_PATH = lib.getExe esbuild;
  patches = [./darkeader.patch];
  src = fetchFromGitHub {
    hash = "sha256-UkVo6GSyGV3U2nn5+IaPdYXqrYh0VgiQx3SApDoI574=";
    owner = "darkreader";
    repo = "darkreader";
    rev = "v${version}";
  };
  installPhase = ''
    mkdir -p $out
    cp build/release/darkreader-firefox.xpi $out/latest.xpi
  '';
}
