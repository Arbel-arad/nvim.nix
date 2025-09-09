{ config, inputs, pkgs, lib, ... }: let

  nvimSize = 0;

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

              pkgs.rshell # For micropython
              pkgs.adafruit-ampy
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

                "micropython.nvim" = {
                  package = pkgs.vimUtils.buildVimPlugin {
                    pname = "micropython.nvim";
                    version = "0";
                    src = pkgs.fetchFromGitHub {
                      owner = "jim-at-jibba";
                      repo = "micropython.nvim";
                      rev = "c1c7f5b4133391ff61b5ae87731caec6d77f377f";
                      hash = "sha256-N9od+q5T42Dm09Vc4y5c2X5OqZ4RPL0mqvVUXwLsLFA=";
                    };
                    dependencies = [
                      pkgs.vimPlugins.toggleterm-nvim
                      pkgs.rshell
                      pkgs.adafruit-ampy
                    ];
                    doCheck = true;
                  };
                  lazy = true;
                  cmd = [
                    "MPRun"
                    "MPSetPort"
                    "MPSetBaud"
                    "MPSetStubs"
                    "MPRepl"
                    "MPInit"
                    "MPUpload"
                    "MPEraseOne"
                    "MPUploadAll"
                  ];
                };

                "nvim-platformio" = {
                  package = pkgs.vimUtils.buildVimPlugin {
                    pname = "nvim-platformio";
                    version = "0";
                    src = pkgs.fetchFromGitHub {
                      owner = "anurag3301";
                      repo = "nvim-platformio.lua";
                      rev = "6df49afd28c6056fe6df031a7edefcc07b5186c8";
                      hash = "sha256-4VeA9+wJHxK0yyHYeGL5yeDi4CIO71ftIdwnKq0+7po=";
                    };
                    dependencies = [
                      pkgs.vimPlugins.telescope-nvim
                      pkgs.vimPlugins.FTerm-nvim
                      pkgs.vimPlugins.plenary-nvim
                      pkgs.platformio-core
                    ];
                    doCheck = true;
                    nvimSkipModule = [
                      "minimal_config"
                    ];
                  };
                  setupOpts = {
                    lsp = "clangd";
                  };
                  lazy = true;
                  cmd = [
                    "Pioinit"
                    "Piorun"
                    "Piocmdh"
                    "Piocmdf"
                    "Piolib"
                    "Piomon"
                    "Piodebug"
                    "Piodb"
                  ];
                };

                "arduino-lsp" = {
                  enabled = false;
                  package = pkgs.vimUtils.buildVimPlugin {
                    pname = "arduino-lsp";
                    version = "0";
                    src = pkgs.fetchFromGitHub {
                      owner = "glebzlat";
                      repo = "arduino-nvim";
                      rev = "086901d0b33a330c2f6e3fe2095ad8166c093e88";
                      hash = "sha256-OHMMV4Bg+3k8BfvVJ0Cz42SX31dsdwfAYJ6w5IPfWyo=";
                    };
                    dependencies = [
                      pkgs.clang-tools
                      pkgs.arduino-cli
                      pkgs.arduino-language-server
                    ];
                    doCheck = true;
                  };
                  setupOpts = {
                    clangd = "${pkgs.clang-tools}/bin/clangd";
                    arduino = "${lib.getExe pkgs.arduino-cli}";
                    capabilities = {
                      textDocument = {
                        foldingRange = {
                          dynamicRegistration = false;
                          lineFoldingOnly = true;
                        };
                      };
                    };
                  };
                  lazy = false;
                  ft = [
                    "ino"
                  ];

                };

                "nvim-arduino" = {
                  enabled = false;
                  package = pkgs.vimUtils.buildVimPlugin {
                    pname = "nvim-arduino";
                    version = "0";
                    src = pkgs.fetchFromGitHub {
                      owner = "yuukiflow";
                      repo = "Arduino-Nvim";
                      rev = "8d1dff82d1c2a248155c9234bddb2c9a82d07a25";
                      hash = "sha256-WTFbo5swtyAjLBOk9UciQCiBKOjkbwLStZMO/0uaZYg=";
                    };
                    dependencies = [
                      pkgs.clang-tools
                      pkgs.arduino-cli
                      pkgs.arduino-language-server
                      pkgs.vimPlugins.telescope-nvim
                      pkgs.vimPlugins.nvim-lspconfig
                    ];
                    doCheck = true;
                    nvimSkipModule = [
                      "init"
                      "libGetter"
                    ];
                  };
                  lazy = false;
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
            };
          };
        };
      } (import ./config/neovim.nix { inherit inputs pkgs lib nvimSize; });
    };
  };
}
