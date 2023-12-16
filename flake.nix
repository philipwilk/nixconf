{
  description = "system definitions";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-matlab = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "gitlab:doronbehar/nix-matlab";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    catppuccin.url = "github:Stonks3141/ctp-nix";
    nix-your-shell = {
      url = "github:MercuryTechnologies/nix-your-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , agenix
    , nix-matlab
    , home-manager
    , catppuccin
    , ...
    } @ inputs:
    let
      systems = [ "x86_64-linux" ];
      machines = nixpkgs.lib.mkMerge
        [
          {
            nixowos = nixpkgs-unstable.lib.nixosSystem;
            nixowos-laptop = nixpkgs-unstable.lib.nixosSystem;
            nixos-thinkcentre-tiny = nixpkgs.lib.nixosSystem;
            hp-dl380p-g8-LFF = nixpkgs.lib.nixosSystem;
          }
        ] ++ map (x: { "hp-dl380p-sff-${x}" = nixpkgs.lib.nixosSystem; }) (nixpkgs.lib.range 2 5);
      nixosConfigurations =
        let
          toSystem = name: val: val {
            specialArgs = inputs;
            modules = (builtins.map (a: ./configs/${a}.nix) [ "nix-settings" "uk-region" ]) ++ [ agenix.nixosModules.default ];
          };
        in
        (builtins.mapAttrs toSystem machines);

      forAllSystems = fn: nixpkgs.lib.genAttrs systems (sys: fn nixpkgs.legacyPackages.${sys});
    in
    {
      nixosConfigurations = (nixosConfigurations // {
        nixowos.modules = [
          ./configs/machines/nixowos/configuration.nix
          ./configs/boot/systemd.nix
          ./configs/kb.nix
          ./configs/workstation.nix
          home-manager.nixosModules.home-manager
          ./configs/home-manager/hm-settings.nix
          catppuccin.nixosModules.catppuccin
        ];
        nixowos-laptop.modules = [
          ./configs/machines/nixowos-laptop/configuration.nix
          ./configs/boot/systemd.nix
          ./configs/kb.nix
          ./configs/workstation.nix
          home-manager.nixosModules.home-manager
          ./configs/home-manager/hm-settings.nix
          catppuccin.nixosModules.catppuccin
        ];
        nixos-thinkcentre-tiny.modules = [
          ./configs/machines/nixos-thinkcentre-tiny/configuration.nix
          ./configs/boot/systemd.nix
          ./configs/server.nix
          ./configs/services/nextcloud.nix
          ./configs/services/openldap.nix
          ./configs/services/navidrome.nix
          ./configs/services/factorio.nix
        ];
        hp-dl380p-g8-LFF.modules = [
          ./configs/machines/hp-dl380p-g8-LFF/configuration.nix
          ./configs/boot/grub.nix
          ./configs/server.nix
        ];
        hp-dl380p-g8-sff-2.modules = [
          ./configs/machines/hp-dl380p-g8-sff-2/configuration.nix
          ./configs/boot/grub.nix
          ./configs/server.nix
        ];
        hp-dl380p-g8-sff-3.modules = [
          ./configs/machines/hp-dl380p-g8-sff-3/configuration.nix
          ./configs/boot/grub.nix
          ./configs/server.nix
        ];
        hp-dl380p-g8-sff-4.modules = [
          ./configs/machines/hp-dl380p-g8-sff-4/configuration.nix
          ./configs/boot/grub.nix
          ./configs/server.nix
        ];
        hp-dl380p-g8-sff-5.modules = [
          ./configs/machines/hp-dl380p-g8-sff-5/configuration.nix
          ./configs/boot/grub.nix
          ./configs/server.nix
        ];
      });
      formatter = forAllSystems (pkgs: pkgs.nixpkgs-fmt);
    };
}
