{ lib, buildNpmPackage, fetchFromGitHub, ... }:
buildNpmPackage rec {
  pname = "github-readme-stats";
  version = "0496044a76bc73a4cd4ed27252bfb986afc743bb";
  src = fetchFromGitHub {
    owner = "anuraghazra";
    repo = "github-readme-stats";
    rev = "${version}";
    hash = "sha256-/odzeuViPrChubDjZY2+SbPbkBV7txLBaBSgB8xeN3w=";
  };

  # Add expressjs as a dependency as suggested in the readme's self-hosting section.
  # In a perfect world I could just add "express" to package.json and let `npm i`
  # update package-lock.json, but that defeats the purpose of reproducability (and
  # nix builds dont have internet access) so it has to all be hardcoded sadly.
  # This patch can be generated by running:
  # `jq --arg name "express" --arg version "4.19.x" '.dependencies[$name] = $version' package.json > package.tmp.json && mv package.tmp.json package.json`
  # followed by `npm i --package-lock-only` and then `git diff > add_expressjs_dep.patch`
  patches = [ ./add_expressjs_dep.patch ];

  dontNpmBuild = true;

  npmDepsHash = "sha256-132YImRaFGBfOhWSO5pDeUm6O2in1vE5VcFLmOvO+so=";

  meta = {
    description = "Dynamically generated stats for your github readmes";
    homepackge = "github-readme-stats.vercel.app";
    license = lib.licenses.mit;
  };
}
