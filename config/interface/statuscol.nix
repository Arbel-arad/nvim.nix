{ pkgs }: {

  extraPlugins = {
    "statuscol.nvim" = {

      package = pkgs.vimPlugins.statuscol-nvim;

      setup = /* lua */ ''
        local builtin = require("statuscol.builtin")
        local c = vim.cmd
        clickmod = "a"

        local function fold_click(args, open, other)
          foldmarker = nil

          if args.button == "l" then -- Open/Close (recursive) fold on (clickmod)-click
            if open then
              c("norm! z"..(args.mods:find(clickmod) and "O" or "o"))
            else
              c("norm! z"..(args.mods:find(clickmod) and "C" or "c"))
            end
          end
        end

        local npc = vim.F.npcall

        require("statuscol").setup {
          relculright = false,

          ft_ignore = {
            'snacks_dashboard',
            'dashboard',
          },
          bt_ignore = {
            'snacks_dashboard',
            'dashboard',
            'nofile',
          },

          segments = {
            { -- Git signs
              sign = {
                namespace = { "gitsigns" },
                maxwidth = 1,
                auto = " "
              },
              click = "v:lua.ScSa",
            },
            { -- Fold indicator
              text = {
                builtin.foldfunc,
                " ",
              },
              sign = {
                auto = "  ",
              },
              click = "v:lua.ScFa",
            },
            { -- Breakpoints / other
              sign = {
                name = { ".*" },
                maxwidth = 1,
                --auto = " ",
                auto = true,
                --wrap = true
              },
              click = "v:lua.ScSa",
            },
            { -- Diagnostics
              sign = {
                namespace = { "diagnostic" },
                maxwidth = 1,
                colwidth = 1,
                auto = " ",
                wrap = true
              },
              click = "v:lua.ScSa",
            },
            { -- Line numbers
              text = {
                builtin.lnumfunc, " "
              },
              click = "v:lua.ScLa",
            },
          },

          clickmod = "a",
          clickhandlers = {
            FoldClose = function(args)
              fold_click(args, true)
            end,
            FoldOpen = function(args)
              fold_click(args, false)
            end,
            FoldOther = function(args)
              --fold_click(args, false, true)
            end,
          }
        }
      '';
    };
  };
}
