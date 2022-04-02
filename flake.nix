rec {
  description = "A very basic flake";

  inputs.sister.url = "path:./sister";
  inputs.sister.inputs.nixpkgs.follows = "nixpkgs";
  inputs.brother.url = "path:./brother";
  inputs.brother.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/21.11";

  outputs = {
    self,
    nixpkgs,
    ...
  } @ args: {
    children = {inherit (args) brother sister;};
    value = "parent";
    siblingValue = "parent";
    values = map (x: x.value) ([self] ++ (builtins.attrValues self.children));

    hash = builtins.hashFile "sha256" ./brother;
    t = (builtins.getFlake "path:./brother").value;

    getWithParent = args.brother.value;

    getWithChild = let
      c = builtins.getFlake (builtins.unsafeDiscardStringContext "path:./brother?narHash=${args.brother.sourceInfo.narHash}");
    in
      c.value;

    callLocklessFlake = path: let
      r = {outPath = path;} //
      (import (path + "/flake.nix")).outputs (args // {self = r;});
    in
      r;

    dynamicGetWithParent = self.callLocklessFlake ./brother;

    dynamicGetWithChild = let
      brother = import ./brother/default.nix;
      brotherFunc = import ./brother/flake.nix;
      r = brotherFunc.outputs (brother.inputs // {self = r;});
    in
      r.value;
  };
}
