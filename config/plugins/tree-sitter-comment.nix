{ npins, pkgs }: let

  grammar = pkgs.tree-sitter.buildGrammar {
    src = npins.tree-sitter-comment;

    version = builtins.substring 0 7 npins.tree-sitter-comment.revision;
    language = "comment";
  };

in {
  treesitter = {
    grammars = [
      grammar
    ];
  };
}
