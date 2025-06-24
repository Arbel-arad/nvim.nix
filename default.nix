{ config, inputs, pkgs, lib, ... }: let

in {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./config/debug.nix
    ./home.nix
  ];
  config = {
    programs = {
      nvf = {
        enable = true;
        enableManpages = true;
        settings = {
          vim = {
            package = inputs.nvim-nightly.packages.${pkgs.system}.neovim;
            viAlias = false;
            vimAlias = true;
            options = {
              tabstop = 2;
              shiftwidth = 2;
              foldlevel = 99;
              foldcolumn = "auto:1";
              fillchars = "eob:‿,fold: ,foldopen:▼,foldsep:⸽,foldclose:⏵";
              mousescroll = "ver:1,hor:1";
              mousemoveevent = true;
              # shortmess = "ltToOCF";

              autoindent = true;
              smartindent = true;
            };

            globals = {
              navic_silence = true; # navic tries to attach multiple LSPs and fails
              suda_smart_edit = 1; # use super user write automatically

              neovide_scale_factor = 0.7;
              neovide_cursor_animation_length = 0.1;
              neovide_cursor_short_animation_length = 0;
            };

            extraPackages = [
              pkgs.platformio-core # for platformio
              pkgs.ccls

              pkgs.imagemagick
              pkgs.fzf
              pkgs.nix
              pkgs.cppcheck
              pkgs.yazi
              pkgs.fish
            ];

            clipboard = {
              enable = true;
              providers = {
                wl-copy.enable = true;
              };
            };

            spellcheck = {
              enable = true;
              programmingWordlist.enable = true;
            };

            lsp = {
              enable = true;
              formatOnSave = false;
              lspkind.enable = true;
              lspsaga = {
                enable = true;
                setupOpts = {
                  ui = {
                    code_action = "🟅";
                  };
                  lightbulb = {
                    sign = false;
                    virtual_text = true;
                  };
                  breadcrumbs.enable = false;
                };
              };
              trouble = {
                enable = true;
                mappings = {
                  documentDiagnostics = null;
                };
                setupOpts = {
                  modes = {
                    diagnostics = {
                      auto_open = true;
                      auto_close = true;
                    };
                  };
                };
              };
              lspSignature.enable = true;
              lspconfig = {
                enable = true;
              };
              otter-nvim = {
                enable = true;
                setupOpts = {
                  buffers.set_filetype = true;
                  lsp = {
                    diagnostic_update_event = [
                      "BufWritePost"
                      "InsertLeave"
                    ];
                  };
                };
              };
              #nvim-docs-view.enable = isMaximal;
              servers = {
                nil = {
                  enable = true;
                  cmd = [ "${lib.getExe pkgs.nil}" ];
                  filetypes = [ "nix" ];
                  root_markers = [
                    "flake.nix"
                    "flake.lock"
                    ".git"
                  ];
                  settings.nil = {
                    diagnostics = {
                      ignored = [
                        "unused_binding"
                        "unused_with"
                      ];
                    };
                  };
                };
                nixd = {
                  enable = true;
                  cmd = [ "${lib.getExe pkgs.nixd}" "--log=error" ];
                  filetypes = [ "nix" ];
                  root_markers = [
                    "flake.nix"
                    "flake.lock"
                    ".git"
                  ];
                  capabilities = {
                    textDocument = {
                      foldingRange = {
                        dynamicRegistration = false;
                        lineFoldingOnly = true;
                      };
                    };
                  };
                };
                "clangd" = {
                  cmd = [ "${pkgs.clang-tools}/bin/clangd" "--clang-tidy" ];
                };
              };
            };


            autocomplete = { # Which is better?
              nvim-cmp = {
                enable = true;
                # setupOpts = lib.generators.mkLuaInline /* lua */ ''
                /*  sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'vsnip' }, -- For vsnip users.
                    -- { name = 'luasnip' }, -- For luasnip users.
                    -- { name = 'ultisnips' }, -- For ultisnips users.
                    -- { name = 'snippy' }, -- For snippy users.
                  }, {
                    { name = 'buffer' },
                  })
                '';*/
                sources = {
                  buffer = "[Buffer]";
                  nvim-cmp = null;
                  #async_path = "[Path]"; # not showing highlight correctly
                  #cmdline = "[cmd]"; # not showing in the cmdline
                  path = "[Path]";
                };
                sourcePlugins = [
                  #pkgs.vimPlugins.cmp-async-path
                  pkgs.vimPlugins.cmp-cmdline
                ];
              };
              blink-cmp = {
                enable = false;
              };
            };


            filetree = {
              neo-tree = {
                enable = true;
                setupOpts = {
                  enable_cursor_hijack = true;
                };
              };
            };

            theme = {
              enable = true;
              name = "catppuccin";
              style = "mocha";
              transparent = false;
            };

            statusline = {
              lualine = {
                enable = true;
                theme = "iceberg_dark";
                setupOpts = {
                  options = {
                    disabled_filetypes = rec {
                      winbar = statusline;
                      statusline = [
                        # DAP-ui
                        "dapui_breakpoints"
                        "dapui_console"
                        "dapui_watches"
                        "dapui_scopes"
                        "dapui_stacks"
                        "dap-repl"

                        # DAP-view
                        "dap-view-term"
                        "dap-view"
                        "dap-repl"

                        # dashboards
                        "dashboard"
                        "startify"
                        "alpha"
                      ];
                    };
                  };
                };
              };
            };

            tabline = {
              nvimBufferline.enable = true;
            };

            treesitter = {
              enable = true;
              addDefaultGrammars = true;
              context = {
                enable = true;
                setupOpts = {
                  mode = "topline";
                  max_lines = 3;
                  min_window_height = 50;
                  separator = null;
                };
              };
              autotagHtml = true;
              highlight = {
                enable = true;
              };
              indent = {
                enable = true;
                disable = [
                  "nix"
                ];
              };
            };

            binds = {
              whichKey.enable = true;
              cheatsheet.enable = true;
            };

            autopairs.nvim-autopairs.enable = true;
            snippets.luasnip.enable = true;

            telescope = {
              enable = true;
              mappings = {

              };
            };

            git = {
              enable = true;
              gitsigns = {
                enable = true;
                codeActions.enable = false; # throws an annoying debug message
              };
            };

            minimap = {
              minimap-vim.enable = false;
              codewindow.enable = true;
            };

            dashboard = { # dashboard-nvim looks better but it's showing the tablines wrong
              #dashboard-nvim.enable = true;
              alpha.enable = true;
            };

            notify = {
              nvim-notify.enable = true;
            };

            projects = {
              project-nvim.enable = true;
            };

            languages = {
              enableFormat = true;
              enableTreesitter = true;
              enableExtraDiagnostics = true;
              enableDAP = true;

              rust = {
                enable = true;
                lsp = {
                  enable = true;
                  opts = /* lua */ ''
                    ['rust-analyzer'] = {
                    cargo = {allFeature = true},
                    checkOnSave = true,
                      procMacro = {
                        enable = true,
                      },
                    },
                  '';
                };
                crates = {
                  enable = true;
                  codeActions = true;
                };
              };
              nix = {
                enable = true;
                lsp = {
                  server = "nixd";
                };
                extraDiagnostics = {
                  enable = true;
                  types = [
                    "statix"
                    "deadnix"
                  ];
                };
              };
              clang = {
                enable = true;
                dap = {
                  enable = true;
                };
              };
              ts = {
                enable = true;
                extraDiagnostics.enable = true;
              };
              python = {
                enable = true;
              };
              zig = {
                enable = true;
              };
              markdown = {
                enable = true;
                extensions = {
                  render-markdown-nvim = {
                    enable = true;
                  };
                };
                extraDiagnostics.enable = true;
              };
              html = {
                enable = true;
              };
              css = {
                enable = true;
              };
              go = {
                enable = true;
              };
              lua = {
                enable = true;
              };
              bash = {
                enable = true;
                extraDiagnostics = {
                  enable = true;
                  types = [
                    "shellcheck"
                  ];
                };
              };
              nu = {
                enable = true;
              };
              assembly = {
                enable = true;
              };
              haskell = {
                enable = true;
              };
              terraform = {
                enable = true;
              };
              sql = {
                enable = true;
                extraDiagnostics.enable = true;
              };
              yaml = {
                enable = true;
              };
              scala = {
                enable = true;
                fixShortmess = false;
              };
            };

            utility = {
              yazi-nvim = {
                enable = true;
              };
              nix-develop.enable = true;
              outline.aerial-nvim = {
                enable = true;
              };
              preview = {
                markdownPreview = {
                  enable = true;
                  autoStart = true;
                  autoClose = true;
                  lazyRefresh = true;
                };
              };
              icon-picker.enable = true;
              diffview-nvim.enable = true;
              images = {
                image-nvim = {
                  enable = true;
                  setupOpts.backend = "kitty";
                };
              };
              motion = {
                precognition = { # helper to learn motions
                  enable = true;
                  setupOpts = {
                    highlightColor = { foreground = "#617a78"; background = "#181818"; };
                    showBlankVirtLine = true;
                    disabled_fts = [
                      "dashboard"
                      "startify"
                      "alpha"
                    ];
                  };
                };
              };
              surround = {
                enable = true;
              };
              ccc = {
                enable = true;
              };
              multicursors = {
                enable = true;
              };
              sleuth.enable = true;
            };

            ui = {
              # illuminate.enable = true; # uses deprecated API
              breadcrumbs = {
                enable = false;
                navbuddy.enable = false;
              };
              modes-nvim = {
                enable = true;
                setupOpts = {
                  colors = {
                    insert = "#75c6df";
                  };
                };
              };
              fastaction = {
                enable = true;
              };
              borders = {
                enable = true;
                plugins = {
                  fastaction.enable = true;
                  lsp-signature.enable = true;
                  nvim-cmp.enable = true;
                };
              };
              nvim-ufo = {
                enable = true;
              };
              noice = {
                enable = true; # should i use this?
              };
            };

            visuals = {
              fidget-nvim.enable = true;
              nvim-web-devicons.enable = true;
              cinnamon-nvim.enable = false; # smooth scroll
              rainbow-delimiters.enable = true;

              nvim-scrollbar = {
                enable = false;
              };

              indent-blankline = {
                enable = true;
                setupOpts = {
                  exclude = {
                    filetypes = [
                      "dashboard"
                      "alpha"
                    ];
                  };
                };
              };
            };

            notes = {
              todo-comments.enable = true;
            };

            terminal = {
              toggleterm = {
                enable = true;
                lazygit.enable = true;
                mappings.open = null;
                setupOpts = {
                  direction = "float";
                  shell = "bash";
                };
              };
            };

            keymaps = [
              {
                key = "<leader>tt";
                mode = ["n"];
                silent = true;
                action = "<cmd>Lspsaga term_toggle<cr>";
                desc = "Lspsaga terminal";
              }
            ];

            luaConfigRC = {

            };

            diagnostics = {
              enable = true;
              config = {
                signs = {
                  text = {
                    "vim.diagnostic.severity.Error" = " ";
                    "vim.diagnostic.severity.Warn" = " ";
                    "vim.diagnostic.severity.Hint" = " ";
                    "vim.diagnostic.severity.Info" = " ";
                  };
                };
                underline = true;
                update_in_insert = true;
                virtual_text = {
                  format = lib.generators.mkLuaInline /* lua */''
                    function(diagnostic)
                      return string.format("%s", diagnostic.message)
                      --return string.format("%s (%s)", diagnostic.message, diagnostic.source)
                    end
                  '';
                };
              };
              nvim-lint = {
                enable = true;
                linters = {

                };
                linters_by_ft = {
                  c = [
                    "cppcheck"
                  ];
                };
              };
            };

            formatter = {
              conform-nvim = {
                enable = true;
              };
            };

            debugger = {
              nvim-dap = {
                enable = true;
                ui.enable = true;
                sources = {
                  clang-debugger = lib.mkForce /* lua */ ''
                    dap.adapters.lldb = {
                      type = 'executable',
                      command = '${pkgs.clang-tools}/bin/lldb-dap',
                      name = 'lldb'
                    }
                    dap.configurations.cpp = {
                      {
                        name = 'Launch',
                        type = 'lldb',
                        request = 'launch',
                        console = "integratedTerminal",
                        program = function()
                          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                        end,
                        cwd = "''${workspaceFolder}",
                        stopOnEntry = false,
                        args = {},
                      },
                      {
                        name = "LaunchWithArgs",
                        type = "lldb",
                        request = "launch",
                        console = "integratedTerminal",
                        args = function()
                          local args_string = vim.fn.input('Arguments: ')
                          return vim.split(args_string, " +")
                        end,
                        program = function()
                          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                        end,
                        stopOnEntry = true,
                        runInTerminal = false,
                      },
                      {
                        name = "LaunchConsole",
                        type = "lldb",
                        request = "launch",
                        console = "integratedTerminal",
                        args = function()
                          local args_string = vim.fn.input('Arguments: ')
                          return vim.split(args_string, " +")
                        end,
                        program = function()
                          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                        end,
                        stopOnEntry = true,
                        runInTerminal = true,
                      },
                    }
                    dap.configurations.c = dap.configurations.cpp
                  '';
                };
              };
            };

            lazy = {
              plugins = {
                "vim-suda" = {
                  package = pkgs.vimPlugins.vim-suda;
                  setupOpts = {

                  };
                  lazy = true;
                  event = ["BufEnter"];
                };
                "rest.nvim" = {
                  package = pkgs.vimPlugins.rest-nvim;
                  setupOpts = {

                  };
                  lazy = true;
                  ft = [
                    "http"
                  ];
                };
                "remote-nvim.nvim" = {
                  package = pkgs.vimPlugins.remote-nvim-nvim;
                  setupOpts = {

                  };
                  lazy = true;
                  event = ["BufEnter"];
                };
                #"nvim-scrollview" = {
                #  package = pkgs.vimPlugins.nvim-scrollview;
                #  setupOpts = {
                #    signs_on_startup = [ "all" ];
                #  };
                #  lazy = true;
                #  event = ["BufEnter"];
                #};
                "vimplugin-nvim-platformio" = let
                  "nvim-platformio" = pkgs.vimUtils.buildVimPlugin {
                    name = "nvim-platformio";
                    src = pkgs.fetchFromGitHub {
                      owner = "anurag3301";
                      repo = "nvim-platformio.lua";
                      rev = "db0af8a0a7e71e613c497812724ff32b7f158df1";
                      hash = "sha256-3DFKkPa0vbBBAEAs4Y4A5m3J6FIBbx70v5mHFe0EXus=";
                    };
                    nvimSkipModule = [
                      "platformio.pioinit"
                      "platformio.piolib"
                      "platformio.piomenu"
                      "minimal_config"
                    ];
                  };
                in {
                  package = nvim-platformio;
                  setupOpts = {

                  };
                  lazy = true;
                };
                "dropbar.nvim" = {
                  package = pkgs.vimPlugins.dropbar-nvim;
                  setupModule = "dropbar";
                  setupOpts = {
                    bar = {
                      hover = true;
                    };
                    menu = {
                      preview = false;
                    };
                  };
                };
              };
            };
            extraPlugins = {
              "statuscol.nvim" = {
                package = pkgs.vimPlugins.statuscol-nvim;
                setup = /*lua*/ ''
                  local builtin = require("statuscol.builtin")
                  local ffi = require("statuscol.ffidef")
                  local C = ffi.C

                  -- only show fold level up to this level
                  local fold_level_limit = 3
                  local function foldfunc(args)
                    local foldinfo = C.fold_info(args.wp, args.lnum)
                    if foldinfo.level > fold_level_limit then
                      return " "
                    end

                    return builtin.foldfunc(args)
                  end

                  require("statuscol").setup {
                    relculright = false,
                    segments = {
                      {
                        text = { " ", builtin.foldfunc, " " },
                        condition = { builtin.not_empty, true, builtin.not_empty },
                        click = "v:lua.ScFa"
                      },
                      { -- not working
                        sign = { namespace = { "diagnostic/signs" }, maxwidth = 2, auto = true },
                        click = "v:lua.ScSa"
                      },
                      { text = { "%s" }, click = "v:lua.ScSa" },
                      { text = { builtin.lnumfunc }, click = "v:lua.ScLa", },
                    }
                  }
                '';
              };
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
                    all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
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
          };
        };
      };
    };
  };
}
