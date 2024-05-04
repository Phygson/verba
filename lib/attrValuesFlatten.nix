{
  attrSet,
  lib,
  ...
}: let
  lst = builtins.attrValues attrSet;
  lst2 = builtins.map (x:
    if ((builtins.typeOf x) == "set")
    then
      import ./attrValuesFlatten.nix {
        attrSet = x;
        inherit lib;
      }
    else [x])
  lst;
in
  lib.lists.flatten lst2
