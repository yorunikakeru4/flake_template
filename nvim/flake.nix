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
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {inherit system;};
        hmPkgs = import home-manager.inputs.nixpkgs {
          system = system;
          overlays = [home-manager.overlay];
        };
        myDotfiles = builtins.fetchGit {
          url = "https://codeberg.org/yorunikakeru/dotfiles";
          ref = "main";
        };
        currentUser = builtins.getEnv "USER";
        currentHome = builtins.getEnv "HOME";
      in {
        homeConfigurations.${currentUser} = home-manager.lib.homeManagerConfiguration {
          pkgs = hmPkgs;
          username = currentUser;
          homeDirectory = currentHome;

          programs.neovim.enable = true;
          programs.neovim.extraConfig = builtins.readFile "${myDotfiles}/nvim/init.lua";

          home.file = builtins.listToAttrs (
            map (
              file: let
                fname = builtins.baseNameOf file;
              in {
                name = ".config/nvim/lua/${fname}";
                value = builtins.readFile "${myDotfiles}/nvim/lua/${fname}";
              }
            ) (builtins.filter (f: builtins.match ".*\\.lua" f != null) (builtins.readDir "${myDotfiles}/nvim/lua"))
          );
        };

        # devShell отдельно (не внутри home-manager)
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.neovim
          ];
        };
      }
    );
}
