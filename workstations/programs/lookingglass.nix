{
  pkgs,
  lib,
  config,
  ...
}:
{
  boot = {
    extraModulePackages = [
      (pkgs.linuxPackages_latest.extend (new: old: {
        kvmfr = old.kvmfr.overrideAttrs {
          patches = [ ];
        };
      })).kvmfr
    ];
    kernelModules = [
      "kvmfr"
    ];
    extraModprobeConfig = ''
      options kvmfr static_size_mb=64
    '';
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="philip", GROUP="kvm", MODE="0660"
  '';

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-glass 0660 philip kvm -"
  ];
  
  home-manager.users.philip.programs.looking-glass-client = {
    enable = true;
    settings = {
      app = {
        shmFile = "/dev/kvmfr0";
      };
    };
  };
}
