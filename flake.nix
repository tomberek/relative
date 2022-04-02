rec {
  description = "A very basic flake";

  inputs.sister.url = "path:./sister";
  inputs.sister.inputs.nixpkgs.follows = "nixpkgs";
  inputs.brother.url = "path:./brother";
  inputs.brother.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/21.11";

  outputs = { self, nixpkgs,... }@args: {
    children = {inherit (args) brother sister;};
    value = "parent";
    siblingValue = "parent";
    values = map (x: x.value) ([self] ++ (builtins.attrValues self.children));

    getWithParent = args.brother.value;

    getWithChild = let
       c = builtins.getFlake (builtins.unsafeDiscardStringContext "path:./brother?narHash=${args.brother.sourceInfo.narHash}");
    in c.value;

    dynamicGetWithParent = (let r = (import ./brother/flake.nix).outputs (args.brother.inputs // { self=r;}); in r ).value;

    dynamicGetWithChild = let
      brother = import ./brother/default.nix;
      brotherFunc = import ./brother/flake.nix;
      r = brotherFunc.outputs (brother.inputs // { self=r;});
    in r.value;

  };
}
