{ pkgs, lib }: {
  autocmds = [
    {
      event = [
        #"BufReadCmd"
        "BufReadPost"
      ];
      pattern = [
        "*.docx"
        "*.rtf"
        "*.odp"
        "*.odt"
      ];

      callback = lib.generators.mkLuaInline /* Lua */ ''
        function(args)
          -- I haven't managed to get proper on-load conversion working right yet
        end
      '';
    }
  ];
}
