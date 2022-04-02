{
  outputs = { self, nixpkgs }: rec {
    value = "sister";
    siblingValue = self.sibling.value;
    parent = builtins.getFlake (builtins.unsafeDiscardStringContext "path:${self.sourceInfo.outPath}?narHash=${self.sourceInfo.narHash}");
    sibling = parent.children.brother;
  };
}
