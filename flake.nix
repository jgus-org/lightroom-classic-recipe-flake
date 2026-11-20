{
  description = "Lightroom Classic on Linux installer recipe";

  inputs = {
    flake-lib.url = "github:jgus-org/flake-lib/v1";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      flake-lib,
      nixpkgs,
      ...
    }:
    let
      source = {
        owner = "6im0n";
        repo = "lightroom-classic-on-linux";
        type = "github";
      };
    in
    flake-lib.lib.eachDefaultSystem (
      system:
      let
        pin = import ./pin.nix;
        pkgs = nixpkgs.legacyPackages.${system};
        orgFormatting = flake-lib.lib.mkFormatting {
          inherit self system;
        };
      in
      {
        checks.formatting = orgFormatting.check;
        formatter = orgFormatting.formatter;
        packages = rec {
          default = lightroom-classic-recipe;
          lightroom-classic-recipe =
            (pkgs.fetchFromGitHub {
              inherit (source) owner repo;
              hash = pin.sourceHash;
              rev = pin.sourceRev;
            }).overrideAttrs
              (old: {
                meta = {
                  license = pkgs.lib.licenses.mit;
                  sourceProvenance = with pkgs.lib.sourceTypes; [ binaryNativeCode ];
                };
                passthru = (old.passthru or { }) // {
                  inherit (pin) sourceRev version;
                };
              });
          update-branches = flake-lib.lib.mkUpdateBranches {
            inherit pkgs source;
            minimumTrackingVersion = "1.2.0";
            pinSchema = "github";
          };
          update-version = flake-lib.lib.mkUpdateVersion {
            inherit pkgs source;
          };
        };
      }
    );
}
