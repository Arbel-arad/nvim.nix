{ lib }: {

  mergeAttrsList =
    list:
    let
      # `binaryMerge start end` merges the elements at indices `index` of `list` such that `start <= index < end`
      # Type: Int -> Int -> Attrs
      binaryMerge =
        start: end:
        # assert start < end; # Invariant
        if end - start >= 2 then
          # If there's at least 2 elements, split the range in two, recurse on each part and merge the result
          # The invariant is satisfied because each half will have at least 1 element
          #binaryMerge start (start + (end - start) / 2) // binaryMerge (start + (end - start) / 2) end
          lib.recursiveUpdate (binaryMerge start (start + (end - start) / 2)) (
            binaryMerge (start + (end - start) / 2) end
          )
        else
          # Otherwise there will be exactly 1 element due to the invariant, in which case we just return it directly
          builtins.elemAt list start;
    in
    if list == [ ] then
      # Calling binaryMerge as below would not satisfy its invariant
      { }
    else
      binaryMerge 0 (builtins.length list);

}
