{ nixpkgs
, nixpkgs-unstable
, lib
, config
, ...
}: {
  nixpkgs = {
    overlays =
      let
        overlay = _: _: {
          unstable = import nixpkgs-unstable { system = "x86_64-linux"; inherit (config.nixpkgs) config; };
        };
      in
      [ overlay ];
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    registry = lib.mapAttrs (_: value: { flake = value; }) {
      inherit nixpkgs nixpkgs-unstable;
    };
    nixPath = lib.mapAttrsToList (key: value: "${ key}=${ value. to. path}") config.nix.registry;
    settings = {
      experimental-features = "nix-command flakes auto-allocate-uids ca-derivations";
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "-d --delete-older-than 14d";
      persistent = true;
    };
  };

  system = {
    autoUpgrade.enable = true;
    stateVersion = "23.05";
  };
}