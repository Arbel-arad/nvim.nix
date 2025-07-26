{ config, inputs, pkgs, lib, ... }: let

  nvimSize = 1;

in {
  imports = [
    inputs.nvf.homeManagerModules.default
    ./home.nix
  ];
  config = {
    programs = {
      nvf = lib.recursiveUpdate {
        settings = {
          vim = {
            extraPackages = [
              pkgs.ccls

              pkgs.imagemagick
              pkgs.fzf
              pkgs.nix
              pkgs.cppcheck
              pkgs.yazi
              pkgs.fish
            ];

            autocomplete = {
              nvim-cmp = {
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
                  #async_path = "[Path]"; # not showing highlight correctly
                  #cmdline = "[cmd]"; # not showing in the cmdline
                };
                sourcePlugins = [
                  #pkgs.vimPlugins.cmp-async-path
                ];
              };
            };

            treesitter = {
              enable = true;
              addDefaultGrammars = true;
              context = {
                enable = true;
                setupOpts = {
                  #multiwindow = true;
                  mode = "topline";
                  max_lines = 3;
                  min_window_height = 50;
                  separator = null;
                  zindex = 10;
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

            notify = {
              nvim-notify.enable = true;
            };

            projects = {
              project-nvim.enable = true;
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
                  autoStart = false;
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

            luaConfigRC = {

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

                "telescope-ui-select.nvim" = {
                  package = pkgs.vimPlugins.telescope-ui-select-nvim;
                  lazy = true;
                };
                "vimplugin-nvim-platformio" = let
                  "nvim-platformio" = pkgs.vimUtils.buildVimPlugin {
                    name = "nvim-platformio";
                    src = pkgs.fetchFromGitHub {
                      owner = "anurag3301";
                      repo = "nvim-platformio.lua";
                      rev = "6df49afd28c6056fe6df031a7edefcc07b5186c8";
                      hash = "sha256-4VeA9+wJHxK0yyHYeGL5yeDi4CIO71ftIdwnKq0+7po=";
                    };
                    doCheck = false;
                    #nvimSkipModule = [
                    #  "platformio.pioinit"
                    #  "platformio.piolib"
                    #  "platformio.piomenu"
                    #  "minimal_config"
                    #];
                  };
                in {
                  package = nvim-platformio;
                  setupModule = "platformio";
#                  setupOpts = {
#                    lsp = "clangd";
#                  };

                  lazy = true;
                  cmd = [ "Pioinit" "Piorun" "Piocmdh" "Piocmdf" "Piolib" "Piomon" "Piodebug" "Piodb" ];
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
      } (import ./config/neovim.nix { inherit inputs pkgs lib nvimSize; });
    };
  };
}
