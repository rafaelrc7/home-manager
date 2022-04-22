{
  description = "Home Manager configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-config = {
      flake = false;
      url = "github:rafaelrc7/nvimrc";
    };
  };

  outputs = { self, nixpkgs, homeManager, nvim-config }: {
    homeConfigurations = {
      "rafael" = homeManager.lib.homeManagerConfiguration rec {
        username = "rafael";
        homeDirectory = "/home/${username}";
        system = "x86_64-linux";

        configuration = {pkgs, ...}: {
          programs.home-manager.enable = true;

          home.packages = with pkgs; [ ];

          xdg.enable = true;
          xdg.userDirs = {
              enable = true;
              createDirectories = true;
          };

          programs.git = {
            enable = true;
            userName = "rafaelrc7";
            userEmail = "rafaelrc7@gmail.com";
            delta.enable = true;
            extraConfig = {
              init.defaultBranch = "master";
              user.editor = "nvim";
              delta.navigate = true;
              merge.conflictStyle = "diff3";
              pull.rebase = true;
            };
            signing = {
              signByDefault = true;
              key = "03F104A08E5D7DFE";
            };
          };

          programs.gh = {
            enable = true;
            settings = {
              editor = "nvim";
              git_protocol = "ssh";
            };
          };

          programs.kitty = {
            enable = true;
            package = pkgs.hello;
            font = {
              package = pkgs.nerdfonts;
              name = "FiraCode Nerd Font Mono";
              size = 12;
            };
            settings = {
              bold_font = "auto";
              italic_font = "auto";
              bold_italic_font = "auto";
              enable_audio_bell = false;
              scrollback_pager_history_size = 2048;
              mouse_map = "left click ungrabbed no-op";
            };
          };

          programs.neovim = {
            enable = true;

            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            withPython3 = true;
            withNodeJs = true;

            extraConfig =''
              lua require('init')
            '';

            extraPackages = with pkgs; [
              clang
              rust-analyzer
              elixir_ls
              nodePackages.vscode-langservers-extracted
              nodePackages.typescript-language-server
              nodePackages.pyright
              sumneko-lua-language-server
              texlab
              rnix-lsp
            ];

            plugins = with pkgs; with vimPlugins; [
              (nvim-treesitter.withPlugins (_: tree-sitter.allGrammars))
              nvim-compe
              nvim-lspconfig
              telescope-nvim
              popup-nvim
              plenary-nvim
              vim-airline
              tmuxline-vim
              vimtex
              markdown-preview-nvim
              symbols-outline-nvim
              nvim-jdtls
              neoformat
              ultisnips
              vim-snippets
              emmet-vim
              nvim-tree-lua
              nvim-web-devicons
              editorconfig-nvim
              vimspector
              undotree
              nerdcommenter
              delimitMate
              vim-dispatch-neovim
              tagbar
              vim-fugitive
              gitsigns-nvim
              gruvbox-nvim
              neorg
              presence-nvim
            ];
          };

          xdg.configFile."nvim/lua" = {
            source = "${nvim-config}/lua";
            recursive = true;
          };

          services.unclutter = {
            enable = true;
            timeout = 3;
          };

          systemd.user.startServices = "sd-switch";
        };

        stateVersion = "22.05";
      };
    };
  };
}

