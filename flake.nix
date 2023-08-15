{
  description = "system definitions";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , agenix
    , ...
    } @ inputs:
    {
      nixosConfigurations = {
        nixowos = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [ ./configs/machines/nixowos/configuration.nix ./configs/boot/systemd.nix ./configs/nix-settings.nix ./configs/uk-region.nix ./configs/workstation.nix agenix.nixosModules.default ];
        };
        nixowos-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [ ./configs/machines/nixowos-laptop/configuration.nix ./configs/boot/systemd.nix ./configs/nix-settings.nix ./configs/uk-region.nix ./configs/workstation.nix agenix.nixosModules.default ];
        };
        nixos-thinkcentre-tiny = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [ ./configs/machines/nixos-thinkcentre-tiny/configuration.nix ./configs/boot/systemd.nix ./configs/nix-settings.nix ./configs/uk-region.nix ./configs/server.nix ./configs/services/nextcloud.nix ./configs/services/openldap.nix agenix.nixosModules.default ];
        };
        hp-dl380p-g8-LFF = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [ ./configs/machines/hp-dl380p-g8-LFF/configuration.nix ./configs/boot/grub.nix ./configs/nix-settings.nix ./configs/uk-region.nix ./configs/server.nix agenix.nixosModules.default ];
        };
      };
    };
}
