{ nvimSize, pkgs }: let

  enableExtra = nvimSize <= 500;

in {
  clipboard = {
    enable = true;

    providers = {
      wl-copy = {
        enable = enableExtra;
      };
    };
  };

  utility = {
    direnv = {
      #enable = true; # still uses old direnv.vim
    };

    yazi-nvim = {
      enable = true;

      # Open at current file with my commonly used shortcut, Toggle mode sometimes jumps up directories
      mappings = {
        yaziToggle = "<leader>-";
        openYazi = "<c-up>";
      };
    };

    nix-develop = {
      enable = true;
    };

    outline.aerial-nvim = {
      enable = true;
    };

    preview = {
      markdownPreview = {
        enable = enableExtra;
        autoStart = false;
        autoClose = true;
        lazyRefresh = true;
      };
    };

    icon-picker = {
      enable = true;
    };

    diffview-nvim = {
      enable = true;
    };

    images = {
      img-clip = {
        # Allow pasting images to markup
        #enable = true;
      };

      image-nvim = {
        enable = true;
        setupOpts = {
          backend = "kitty";

          editor_only_render_when_focused = true;

          window_overlap_clear_enabled = true;
          window_overlap_clear_ft_ignore = [
            "cmp_menu"
            "cmp_docs"
            "snacks_notif"
            "scrollview"
            "scrollview_sign"
          ];

          # Unclear if this section works
          editorOnlyRenderWhenFocused = true;
          windowOverlapClear = {
            enable = true;
            ftIgnore = [
              "cmp_menu"
              "cmp_docs"
              ""
            ];
          };

          maxHeightWindowPercentage = 35;
          maxWidthWindowPercentage = 100;

          integrations = let

            default = {
              clear_in_insert_mode = true;
              download_remote_images = false;
              only_render_image_at_cursor = true;
              only_render_image_at_cursor_mode = "inline";
            };

          in {
            markdown = default // {
              enable = true;
              clearInInsertMode = true;
              onlyRenderAtCursor = true;
            };

            neorg = default // {
              enable = true;
              clearInInsertMode = true;
              onlyRenderAtCursor = true;
            };

            typst = default;

            html = default;
            css = default;
          };

          hijackFilePatterns = [
            "*.png"
            "*.jpg"
            "*.jpeg"
            "*.gif"
            "*.webp"
          ];
        };
      };
    };

    surround = {
      enable = true;
      # Use alternative set of keybindings that avoids conflicts with other plugins
      useVendoredKeybindings = true;
    };

    multicursors = {
      enable = true;
    };

    ccc = {
      enable = true;
    };

    sleuth = {
      enable = true;
    };

    undotree = {
      enable = true;
    };
  };

  notes = {
    # (partially) Replaced with https://github.com/oxy2dev/tree-sitter-comment
    todo-comments = {
      enable = true;
    };

    neorg = {
      enable = true;
      treesitter = {
        enable = true;
      };
      setupOpts = {
        load = {
          "core.defaults" = {
            enable = true;
          };

          "core.concealer" = {
            enable = true;
            config = {

            };
          };

          "core.completion" = {
            enable = true;
            config = {
              engine = "nvim-cmp";
            };
          };
        };
      };
    };
  };
}
