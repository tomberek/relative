rec {
  description = "A very basic flake";

  inputs.sister.url = "path:./sister";
  inputs.brother.url = "path:./brother";
  inputs.nixpkgs.url = "nixpkgs";

  outputs = { self, nixpkgs,... }@args: {
    children = {inherit (args) brother sister;};
    value = "parent";
    siblingValue = "parent";
    values = map (x: x.value) ([self] ++ (builtins.attrValues self.children));
  };
}
