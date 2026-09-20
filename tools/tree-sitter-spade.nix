{ pkgs, npins }: pkgs.tree-sitter.buildGrammar {
  src = npins.tree-sitter-spade;

  version = "0";

  language = "spade";
}
