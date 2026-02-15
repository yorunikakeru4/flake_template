{
  description = "Basic Lua dev environment";

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
          pkgs.nil # Language server
          pkgs.alejandra # Formatter
          pkgs.statix # Linter
          pkgs.deadnix # Dead code detection
        ];

        shellHook = ''
          echo "$(lua --version)"

        '';
      };
    });
}
