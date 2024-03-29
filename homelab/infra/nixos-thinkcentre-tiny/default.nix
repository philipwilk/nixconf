{ ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  homelab = {
    enable = true;
    isLeader = true;
    tld = "fogbox.uk";
    acme.mail = "philip.wilk10@gmail.com";
    services = {
      nextcloud = {
        enable = true;
        domain = "nextcloud.philipw.uk";
      };
      navidrome.enable = true;
      factorio = {
        enable = true;
        admins = [ "wiryfuture" ];
      };
      openldap.enable = true;
      uptime-kuma.enable = true;
      vaultwarden.enable = true;
      mediawiki = {
        enable = true;
        name = "Reading CS lore";
        domain = "lore.fogbox.uk"; 
      };
    };
  };

  networking = {
    hostName = "nixos-thinkcentre-tiny";
    firewall.interfaces."eno1".allowedTCPPorts = [ 80 443 ];
  };
}
