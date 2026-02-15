{
  description = "Basic Go dev environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.dog
          pkgs.go
          pkgs.gosimports
          pkgs.golines
          pkgs.golangci-lint
          pkgs.gofumpt
          pkgs.gotools
          pkgs.go-swagger
          pkgs.go-task
          pkgs.delve # Debugger
        ];

        shellHook = ''
          echo "$(go --version)"

        '';
      };
    });
}
