{ self, pkgs, lib }: let

  header = lib.generators.mkLuaInline ''[[

N  E  O -- V  I  M

  ]]'';

in {

  dashboard = {
    dashboard-nvim = {
      #enable = true;

      setupOpts = {
        theme = "doom";

        config = {
          header = {};
          center = [
            {
              icon = " ";
              icon_hl = "Title";
              desc = "Find File           ";
              desc_hl = "String";
              key = "b";
              keymap = "SPC f f";
              key_hl = "Number";
              key_format = " %s"; # -- remove default surrounding `[]`
              action = "NeovimProjectHistory";
            }
         ];
          footer = {};
        };
      };
    };

    alpha = {
      #enable = true;

      theme = "theta";

      layout = [

      ];

      opts = {

      };
    };
  };

  utility = {
    snacks-nvim = {
      enable = true;

      setupOpts = {
        picker = {
          ui_select = false;
        };

        #quickfile = {

        #};

        dashboard = {
          preset = {
            #pick = "telescope.nvim";
            keys = lib.generators.mkLuaInline /* Lua */ ''
              {
                { icon = " ", key = "g", desc = "Find Text", action = "<leader>fg" },
                { icon = " ", key = "f", desc = "Find File", action = "<cmd>Telescope find_files<CR>" },
                { icon = " ", key = "d", desc = "Find project", action = "<cmd>NeovimProjectHistory<CR>"},
                { icon = "󰺄 ", key = "a", desc = "All projects", action = "<cmd>NeovimProjectDiscover<CR>"},
                { icon = " ", key = "n", desc = "New File", action = "<cmd>ene | startinsert<CR>" },
                { icon = " ", key = "r", desc = "Recent Files", action = "<cmd>Telescope oldfiles<CR>" },
                { icon = " ", key = "s", desc = "Restore Session", action = "<cmd>NeovimProjectLoadRecent<CR>"},
                { icon = " ", key = "q", desc = "Quit", action = "<cmd>qa<CR>" },
                { icon = " ", key = "c", desc = "Config",
                  action = function()
                    local path = vim.fn.stdpath('config')
                    vim.cmd("cd " .. path)
                    vim.cmd("Telescope find_files")
                  end,
                  hidden = true,
                },
              },
            '';

            inherit header;
          };

          sections = [
            {
              section = "terminal";
              cmd = "${import (self + /tools/colorprint) { inherit pkgs; }}/bin/colorprint";
              align = "center";
              indent = 23;
            }
            {
              section = "header";
            }
            {
              section = "keys";
              gap = 1;
              padding = 1;
            }
            {
              icon = " ";
              title = "Recent Files";
              section = "recent_files";
              limit = 3;
              indent = 2;
              padding = 1;
            }
            {
              icon = " ";
              title = "Projects";
              section = "projects";
              limit = 3;
              indent = 2;
              padding = 1;
            }


            (lib.generators.mkLuaInline /* Lua */ ''
              function()
                -- Disable folding on dashboard?
                vim.opt_local.foldenable = false

                local in_git = Snacks.git.get_root() ~= nil
                local cmds = {
                  {
                    icon = " ",
                    title = "Git Status",
                    cmd = "git --no-pager diff --stat -B -M -C",
                    height = 10,
                  },
                }
                return vim.tbl_map(function(cmd)
                  return vim.tbl_extend("force", {
                    pane = 1,
                    section = "terminal",
                    enabled = in_git,
                    padding = 1,
                    align = "center",
                    ttl = 5 * 60,
                    indent = 3,
                  }, cmd)
                end, cmds)
              end,
            '')
          ];
        };
      };
    };
  };
}
