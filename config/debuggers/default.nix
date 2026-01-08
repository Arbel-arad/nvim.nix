{ nvimSize, npins, pkgs, lib }: let

enableExtra = nvimSize <= 100;

in {

  extraPackages = lib.optionals enableExtra [
    pkgs.qemu_full
    pkgs.openocd
    pkgs.gcc-arm-embedded
  ];

  keymaps = [
    # TODO: add argument prompt
    # Also add function to automatically select rust-specific debugger
    {
      mode = [
        "n"
      ];
      key = "<leader>rdd";
      action = "<cmd>DapNew<cr>";
      desc = "DapNew";
    }
    {
      mode = [
        "n"
      ];
      key = "<leader>rdr";
      action = "<cmd>RustLsp debug<cr>";
      desc = "Debug rust";
    }
    {
      mode = [
        "n"
      ];
      key = "<leader>rdu";
      action = /* lua */''
        function()
          require('dapui').toggle()
        end
      '';
      lua = true;
      desc = "DapUi toggle";
    }
    {
      mode = [
        "n"
      ];
      key = "<leader>rdv";
      action = "<cmd>DapViewToggle<cr>";
      desc = "Dapview toggle";
    }
  ];

  debugger = lib.mkIf enableExtra {
    nvim-dap = {
      enable = true;

      ui = {
        enable = true;
        autoStart = true;

        setupOpts = {
          /*layouts = [
            {
              elements = [
                {
                  id = "disassembly";
                }
              ];
              position = "bottom";
              size = 0.15;
            }
          ];*/
        };
      };

      sources = {
        clang-debugger = lib.mkForce (import ./lldb.nix {
          inherit pkgs;
        });

        gdb-debugger = import ./gdb.nix {
          inherit pkgs lib;
        };

        probe-rs-debugger = import ./probe-rs.nix {
          inherit pkgs;
        };

        /* bashdb seems to be broken
        bash-debugger = import ./bashdb.nix {
          inherit pkgs lib;
        };
        */
      };
    };
  };

  /*
  startPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      pname = "nvim-dap-disasm";
      version = "0";

      src = npins."nvim-dap-disasm";

      optional = false;

      dependencies = [
        pkgs.vimPlugins.nvim-dap
      ];
    })
  ];
  */

  lazy = {
    plugins = {
      # Need to fix loading order for nvim-dap-ui
      "nvim-dap-disasm" = {
        enabled = true;

        package = pkgs.vimUtils.buildVimPlugin {
          pname = "nvim-dap-disasm";
          version = "0";

          src = npins."nvim-dap-disasm";

          dependencies = [
            pkgs.vimPlugins.nvim-dap
            #pkgs.vimPlugins.nvim-dap-view
          ];
        };

        /*
        setupModule = "dap-disasm";
        setupOpts = {
          dapui_register = false;
          dapview_register = true;
        };
        */

        lazy = false;
      };

      "nvim-dap-view" = {
        package = pkgs.vimPlugins.nvim-dap-view;

        setupModule = "dap-view";
        setupOpts = {
          windows = {
            position = "right";
          };

          winbar = {
            controls = {
              #enabled = true;
            };

            sections = [
              "watches"
              "scopes"
              "exceptions"
              "breakpoints"
              "threads"
              "repl"
              "disassembly"
              "console"
            ];

            default_section = "disassembly";
          };
        };

        lazy = true;

        cmd = [
          "DapViewToggle"
        ];

        after = /* lua */ ''
          require("dap-disasm").setup({
            -- Add disassembly view to elements of nvim-dap-ui
            dapui_register = false,

            -- Add disassembly view to nvim-dap-view
            dapview_register = true,

            -- If registered, pass section configuration to nvim-dap-view
            dapview = {
              keymap = "D",
              label = "Disassembly [D]",
              short_label = "󰒓 [D]",
            },

            -- Show winbar with buttons to step into the code with instruction granularity
            -- This settings is overriden (disabled) if the dapview integration is enabled and the plugin is installed
            winbar = true,

            -- The sign to use for instruction the exectution is stopped at
            sign = "DapStopped",

            -- Number of instructions to show before the memory reference
            ins_before_memref = 16,

            -- Number of instructions to show after the memory reference
            ins_after_memref = 16,

            -- Labels of buttons in winbar
            controls = {
              step_into = "Step Into",
              step_over = "Step Over",
              step_back = "Step Back",
            },

            -- Columns to display in the disassembly view
            columns = {
              "address",
              "instructionBytes",
              "instruction",
            },
          })
        '';
      };
    };
  };

  extraPlugins = {
   "nvim-dap-virtual-text" = {
      package = pkgs.vimPlugins.nvim-dap-virtual-text;
      setup = /* lua */ ''
        require("nvim-dap-virtual-text").setup {
          enabled = true,                        -- enable this plugin (the default)
          enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
          highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
          highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
          show_stop_reason = true,               -- show stop reason when stopped for exceptions
          commented = false,                     -- prefix virtual text with comment string
          only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
          all_references = true,                -- show virtual text on all all references of the variable (not only definitions)
          clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
          --- A callback that determines how a variable is displayed or whether it should be omitted
          --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
          --- @param buf number
          --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
          --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
          --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
          --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
          display_callback = function(variable, buf, stackframe, node, options)
          -- by default, strip out new line characters
            if options.virt_text_pos == 'inline' then
              return ' = ' .. variable.value:gsub("%s+", " ")
            else
              return variable.name .. ' = ' .. variable.value:gsub("%s+", " ")
            end
          end,
          -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
          virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

          -- experimental features:
          all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
          virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
          virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
                                                  -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
        }
      '';
    };
  };
}
