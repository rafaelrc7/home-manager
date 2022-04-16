{
  description = "Home Manager configuration flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    homeManager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, homeManager }: {
    homeConfigurations = {
      "rafael" = homeManager.lib.homeManagerConfiguration rec {
        username = "rafael";
        homeDirectory = "/home/${username}";
        system = "x86_64-linux";

        configuration = {pkgs, ...}: {
          programs.home-manager.enable = true;

          home.packages = [ pkgs.hello ];

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

          systemd.user.startServices = "sd-switch";
        };

        stateVersion = "22.05";
      };
    };
  };
}

