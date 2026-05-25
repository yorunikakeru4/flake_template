{
  description = "NOTE: Go project development and build flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    treefmt-nix,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };

      # NOTE: Change this to your module/binary name (matches the last segment of go.mod module path).
      packageName = "base";

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";

        programs.alejandra.enable = true;
        programs.gofmt.enable = true;
      };

      app = pkgs.buildGoModule {
        pname = packageName;

        # NOTE: Fill this when you start versioning releases.
        version = "0.1.0";

        src = ./.;

        # NOTE:
        # Run `nix build` once with vendorHash = pkgs.lib.fakeHash, then replace
        # the fake hash with the real one printed in the error message.
        # Set to null if you use a vendor/ directory committed to the repo.
        vendorHash = pkgs.lib.fakeHash;

        # NOTE:
        # Set to true when your tests do not require external services.
        # For integration tests with Postgres/Redis/etc, keep false and run them separately.
        doCheck = false;
      };
    in {
      packages = {
        default = app;

        # NOTE: This exposes `nix build .#base`.
        # Rename this attr together with `packageName`.
        ${packageName} = app;
      };

      apps = let
        defaultApp =
          (flake-utils.lib.mkApp {
            drv = app;

            # NOTE:
            # Set this only if the binary name differs from packageName.
            # exePath = "/bin/${packageName}";
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

      devShells.default = pkgs.mkShell {
        inputsFrom = [app];

        packages = [
          pkgs.go
          pkgs.gopls
          pkgs.golangci-lint
          pkgs.delve
          pkgs.just

          treefmtEval.config.build.wrapper
        ];

        shellHook = ''
          echo "$(go version)"
        '';
      };
    });
}
