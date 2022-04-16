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

          systemd.user.startServices = "sd-switch";
        };

      };
    };
  };
}

