{
  description = "Neovim flake with Codeberg dotfiles and devShell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    home-manager,
  }: let
    myDotfiles = builtins.fetchGit {
      url = "https://codeberg.org/yorunikakeru/dotfiles";
      ref = "main";
    };
  in {
    homeConfigurations = flake-utils.lib.eachDefaultSystem (system: let
      hmPkgs = import home-manager.inputs.nixpkgs {
        system = system;
        overlays = [home-manager.overlay];
      };
      currentUser = builtins.getEnv "USER";
      currentHome = builtins.getEnv "HOME";
    in {
      "${currentUser}" = home-manager.lib.homeManagerConfiguration {
        pkgs = hmPkgs;
        username = currentUser;
        homeDirectory = currentHome;

        programs.neovim.enable = true;
        programs.neovim.extraConfig = builtins.readFile "${myDotfiles}/nvim/init.lua";
      };
    });

    # devShell топ-левел
    devShells = {
      default = import nixpkgs {system = "x86_64-linux";}.mkShell {
        buildInputs = [
          import
          nixpkgs
          {system = "x86_64-linux";}.neovim
        ];
      };
    };
  };
}
