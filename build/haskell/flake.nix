{
  description = "NOTE: Haskell Cabal project development and build flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    systems.url = "github:nix-systems/default";

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    systems,
    treefmt-nix,
    ...
  }:
    flake-utils.lib.eachSystem (import systems) (system: let
      pkgs = import nixpkgs {inherit system;};

      # NOTE: Change this to match your .cabal package name.
      packageName = "base";

      # NOTE:
      # haskellPackages uses GHC from nixpkgs stable set.
      # To pin a specific GHC version use e.g.:
      #   pkgs.haskell.packages.ghc966
      #   pkgs.haskell.packages.ghc947
      haskellPkgs = pkgs.haskellPackages;

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";

        programs.alejandra.enable = true;
        programs.ormolu.enable = true;
      };

      # NOTE:
      # callCabal2nix reads the .cabal file at build time.
      # Requires a valid <packageName>.cabal file in the project root.
      app = haskellPkgs.callCabal2nix packageName ./. {};
    in {
      packages = {
        # NOTE: justStaticExecutables strips the GHC runtime from the binary.
        default = pkgs.haskell.lib.justStaticExecutables app;

        # NOTE: This exposes `nix build .#base`.
        # Rename this attr together with `packageName`.
        ${packageName} = pkgs.haskell.lib.justStaticExecutables app;
      };

      apps = let
        defaultApp =
          (flake-utils.lib.mkApp {
            drv = pkgs.haskell.lib.justStaticExecutables app;
          })
          // {
            meta.description = "Run ${packageName}";
          };
      in {
        default = defaultApp;

        # NOTE: This exposes `nix run .#base`.
        # Rename this attr together with `packageName`.
        ${packageName} = defaultApp;
      };

      checks = {
        # NOTE: This makes `nix flake check` build the package.
        ${packageName} = app;

        formatting = treefmtEval.config.build.check self;
      };

      formatter = treefmtEval.config.build.wrapper;

      devShells.default = haskellPkgs.shellFor {
        packages = p: [app];

        # NOTE: Builds Hoogle index for all dependencies.
        withHoogle = true;

        buildInputs = [
          haskellPkgs.haskell-language-server
          pkgs.cabal-install
          pkgs.hlint
          pkgs.just
          treefmtEval.config.build.wrapper
        ];
      };
    });
}
