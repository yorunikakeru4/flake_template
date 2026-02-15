{
  description = "My Nix flake templates";

  outputs = {self}: {
    templates = {
      python_template = {
        path = ./python;
        description = "Python dev shell";
      };

      go_template = {
        path = ./go;
        description = "Go dev shell";
      };

      rust_template = {
        path = ./rust;
        description = "Rust dev shell";
      };

      elixir_template = {
        path = ./elixir;
        description = "Elixir dev shell";
      };

      lua_template = {
        path = ./lua;
        description = "Lua dev shell";
      };

      php_template = {
        path = ./php;
        description = "PHP dev shell";
      };

      js_template = {
        path = ./js;
        description = "JavaScript dev shell";
      };

      base_template = {
        path = ./base;
        description = "Base dev shell";
      };
    };
  };
}
