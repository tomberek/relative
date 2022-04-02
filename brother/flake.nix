{
  outputs = { self, nixpkgs }: rec {
    value = "brother";
    siblingValue = self.sibling.value;
    parent = builtins.getFlake (builtins.unsafeDiscardStringContext "path:${self.sourceInfo.outPath}?narHash=${self.sourceInfo.narHash}");
    sibling = parent.children.sister;
  };
}
