{
  description = "A flake giving access to fonts that I use, outside of nixpkgs.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultPackage = pkgs.symlinkJoin {
          name = "myfonts-0.1";
          paths = builtins.attrValues self.packages.${system}; # Add font derivation names here
        };

        packages.monolisa = pkgs.stdenvNoCC.mkDerivation {
          name = "monolisa-font";
          dontConfigure = true;
          src = pkgs.fetchFromGitHub {
            owner = "kashfr";
            repo = "monolisa";
            rev = "9c5f4fb33a0005049e091d623f19b73f1e0f46cd";
            sha256 = "1as3zn60s9xiqgjx9qhav475m3mmxrgm2psj9dr028xv7ww753x5";
          };
          installPhase = ''
            mkdir -p $out/share/fonts/truetype
            cp -R $src/fonts/*.ttf $out/share/fonts/truetype/
          '';
          meta = { description = "A MonoLisa Font Family derivation."; };
        };
      });
}