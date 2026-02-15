{
  description = "Neovim flake with Codeberg dotfiles and devShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
  }: let
    # Dotfiles из Codeberg
    myDotfiles = builtins.fetchGit {
      url = "https://codeberg.org/yorunikakeru/dotfiles";
      ref = "main";
    };

    # Функция для создания home-manager конфигурации
    mkHomeConfig = {
      pkgs,
      username,
      homeDirectory,
    }:
      home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home = {
              inherit username homeDirectory;
              stateVersion = "24.11";
            };

            programs.neovim = {
              enable = true;
              defaultEditor = true;
              initLua = builtins.readFile "${myDotfiles}/nvim/init.lua";
            };
          }
        ];
      };
  in
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        # nix develop
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            neovim
            git
            ripgrep
            fd
          ];

          shellHook = ''
            echo "Dev shell loaded. Neovim ready."
          '';
        };

        # nix run .#homeActivate -- [username] [home_dir]
        # Или с --impure для автоопределения
        apps.homeActivate = {
          type = "app";
          program = toString (pkgs.writeShellScript "activate-home" ''
            set -e

            USERNAME="''${1:-''${USER:-$(whoami)}}"
            HOME_DIR="''${2:-''${HOME:-/home/$USERNAME}}"

            echo "Activating home-manager for: $USERNAME ($HOME_DIR)"

            ${pkgs.nix}/bin/nix build --impure --expr "
              let
                flake = builtins.getFlake \"path:$(pwd)\";
                pkgs = import ${nixpkgs} { system = \"${system}\"; };
              in
                (flake.lib.mkHomeConfig {
                  inherit pkgs;
                  username = \"$USERNAME\";
                  homeDirectory = \"$HOME_DIR\";
                }).activationPackage
            " -o result

            ./result/activate
          '');
        };

        # Пакет neovim с конфигом
        packages.neovim-configured = pkgs.neovim.override {
          configure = {
            customRC = ''
              luafile ${myDotfiles}/nvim/init.lua
            '';
          };
        };

        packages.default = self.packages.${system}.neovim-configured;
      }
    )
    // {
      lib.mkHomeConfig = mkHomeConfig;
    };
}
