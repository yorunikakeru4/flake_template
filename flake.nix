{
  description = "My Nix flake templates";

  outputs = {self}: {
    templates = {
      python-dev = {
        path = ./dev/python;
        description = "Python dev shell";
      };

      go-dev = {
        path = ./dev/go;
        description = "Go dev shell";
      };

      rust-dev = {
        path = ./dev/rust;
        description = "Rust dev shell";
      };

      rust-build = {
        path = ./build/rust;
        description = "Rust build shell";
      };

      elixir-dev = {
        path = ./dev/elixir;
        description = "Elixir dev shell";
      };

      lua-dev = {
        path = ./dev/lua;
        description = "Lua dev shell";
      };

      cpp-dev = {
        path = ./dev/cpp;
        description = "CPP dev shell";
      };

      cpp-build = {
        path = ./build/cpp;
        description = "CPP build shell";
      };

      c-sharp-dev = {
        path = ./dev/c-sharp;
        description = "C# dev shell";
      };

      android-dev = {
        path = ./dev/android;
        description = "Android dev shell";
      };

      android-build = {
        path = ./build/android;
        description = "Android build shell";
      };

      php-dev = {
        path = ./dev/php;
        description = "PHP dev shell";
      };

      js-dev = {
        path = ./dev/js;
        description = "JavaScript dev shell";
      };

      nix-dev = {
        path = ./dev/nix;
        description = "Nix dev shell";
      };

      base = {
        path = ./base;
        description = "Base dev shell";
      };

      nvim = {
        path = ./nvim;
        description = "Neovim dev shell";
      };
    };
  };
}
