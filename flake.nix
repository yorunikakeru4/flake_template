{
  description = "My Nix flake templates";

  outputs = {self}: {
    templates = {
      python = {
        path = ./python;
        description = "Python dev shell";
      };

      go = {
        path = ./go;
        description = "Go dev shell";
      };

      rust = {
        path = ./rust;
        description = "Rust dev shell";
      };

      elixir = {
        path = ./elixir;
        description = "Elixir dev shell";
      };

      lua = {
        path = ./lua;
        description = "Lua dev shell";
      };

      php = {
        path = ./php;
        description = "PHP dev shell";
      };

      js = {
        path = ./js;
        description = "JavaScript dev shell";
      };

      nix = {
        path = ./nix;
        description = "Nix dev shell";
      };
      nvim = {
        path = ./nvim;
        description = "Neovim dev shell";
      };
      base = {
        path = ./base;
        description = "Base dev shell";
      };
    };
  };
}
