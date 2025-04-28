{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      devShells = {
        default = pkgs.mkShell {
          packages = [pkgs.hugo pkgs.dart-sass];
        };
      };

      packages = rec {
        website = pkgs.stdenv.mkDerivation {
          name = "nakibrayan.com";
          src = ./.;

          buildInputs = [pkgs.hugo pkgs.dart-sass];

          buildPhase = "hugo";

          installPhase = "cp --recursive ./public $out";
        };
        default = website;
      };
    });
}
