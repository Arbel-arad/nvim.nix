{ lib }: {

  mergeAttrsList = list:
  let
    mergeAttrs = a: b:
      lib.mapAttrs
        (name: value:
          if (builtins.hasAttr name b) then
            let other = b.${name}; in
            if builtins.isList value && builtins.isList other then
              # Both are lists => concatenate
              value ++ other
            else if builtins.isAttrs value && builtins.isAttrs other then
              # Both are attrsets => merge recursively
              mergeAttrs value other
            else
              # Otherwise, override with B's value
              other
          else
            # If key only exists in A => keep A's value
            value
        )
        a
      # Add keys that exist only in B
      // lib.filterAttrs (n: _: !(builtins.hasAttr n a)) b;



    binaryMerge = start: end:
      if end - start >= 2 then
        mergeAttrs
          (binaryMerge start (start + (end - start) / 2))
          (binaryMerge (start + (end - start) / 2) end)
      else
        builtins.elemAt list start;


  in
  # If list is empty, return empty attrset
  if list == [] then
    {}
  else
    # Merge entire list range
    binaryMerge 0 (builtins.length list);

}
