{
  inputs.flake-compat = {
  url = "github:edolstra/flake-compat";
  flake = false;
  };
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  outputs = {  nixpkgs, ... }: rec {
    value = "brother:" + (builtins.readFile "${nixpkgs.outPath}/.version");
    #siblingValue = self.sibling.value;
    #parent = builtins.getFlake (builtins.unsafeDiscardStringContext "path:${self.sourceInfo.outPath}?narHash=${self.sourceInfo.narHash}");
    #sibling = parent.children.sister;
  };
}
