{
  description = "C++ CMake project";

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
      lib = pkgs.lib;

      packageName = "base";

      treefmtEval = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";

        programs.alejandra.enable = true;
        programs.clang-format.enable = true;
        programs.cmake-format.enable = true;
      };

      app = pkgs.stdenv.mkDerivation {
        pname = packageName;
        version = "0.1.0";

        src = lib.cleanSource ./.;

        nativeBuildInputs = with pkgs; [
          cmake
          ninja
          pkg-config
        ];

        cmakeFlags = [
          "-DCMAKE_BUILD_TYPE=Release"
        ];
      };
    in {
      packages.default = app;

      apps.default =
        (flake-utils.lib.mkApp {
          drv = app;
        })
        // {
          meta.description = "Run ${packageName}";
        };

      checks = {
        default = app;
        formatting = treefmtEval.config.build.check self;
      };

      formatter = treefmtEval.config.build.wrapper;

      devShells.default = pkgs.mkShell {
        inputsFrom = [app];

        packages = with pkgs;
          [
            clang-tools
            cmake-language-server
            ccache
            treefmtEval.config.build.wrapper
          ]
          ++ lib.optionals stdenv.isLinux [
            gdb
          ];
      };
    });
}
