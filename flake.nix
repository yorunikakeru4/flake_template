{
  description = "My Nix flake templates";

  outputs = {self}: {
    templates = {
      template = {
        path = ./template;
        description = "Python dev shell";
      };
    };
  };
}
