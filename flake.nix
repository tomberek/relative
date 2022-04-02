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

    # Use parent's inputs
    getWithParent = args.brother.value;

    # Read child's lockfile to create inputs
    getWithChild = let
      c = builtins.getFlake (builtins.unsafeDiscardStringContext "path:./brother?narHash=${args.brother.sourceInfo.narHash}");
    in
      c.value;

    lib.callLocklessFlake = path: inputs: let
      r = {outPath = path;} //
      ((import (path + "/flake.nix")).outputs (inputs // {self = r;}));
    in
      r;

    # Use parent's inputs
    dynamicGetWithParent = (self.lib.callLocklessFlake ./brother args).value;

    # Read child's lockfile to create inputs
    dynamicGetWithChild = (self.lib.callLocklessFlake ./brother (import ./brother/default.nix).inputs ).value;
  };
}
