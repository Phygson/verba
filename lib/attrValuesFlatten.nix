lib: attrSet: let
  lst = builtins.attrValues attrSet;
  lst2 = builtins.map (x:
    if ((builtins.typeOf x) == "set")
    then import ./attrValuesFlatten.nix lib x
    else x)
  lst;
in
  lib.lists.flatten lst2
