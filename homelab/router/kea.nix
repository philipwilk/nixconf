{ config, lib, ... }:
let
  domain = config.homelab.router.kea.hostDomain;
  router.ip4 = "192.168.1.0";
in
{
  config = lib.mkIf config.homelab.router.kea.enable {
    networking.interfaces.${config.homelab.router.devices.lan}.ipv4.addresses = [
      {
        address = router.ip4;
        prefixLength = 16;
      }
    ];
    services.kea = {
      dhcp4 = {
        enable = true;
        settings = {
          interfaces-config = {
            interfaces = [ config.homelab.router.devices.lan ];
          };
          lease-database = {
            name = "/var/lib/kea/dhcp4.leases";
            persist = true;
            type = "memfile";
          };
          rebind-timer = 2000;
          renew-timer = 1000;
          valid-lifetime = 4000;

          subnet4 = [
            {
              id = 1;
              pools = [ { pool = "192.168.1.101 - 192.168.1.245"; } ];
              subnet = config.homelab.router.kea.lanRange.ip4;
              option-data = [
                {
                  name = "domain-name-servers";
                  data = router.ip4;
                }
                {
                  name = "routers";
                  data = router.ip4;
                }
                {
                  name = "domain-name";
                  data = domain;
                }
                {
                  name = "ntp-servers";
                  data = router.ip4;
                }
              ];
              interface = config.homelab.router.devices.lan;
              # ip and hostname reservations
              reservations = [
                # Wifi AP
                {
                  hw-address = "98:42:65:76:de:b3";
                  ip-address = "192.168.1.1";
                  hostname = "toob-ap";
                }
                # Tinyminimicro node
                {
                  hw-address = "44:8a:5b:de:13:28";
                  ip-address = "192.168.1.10";
                  hostname = "thinkcentre";
                }
                # Lights out management
                {
                  hw-address = "54:9f:35:14:57:3e";
                  ip-address = "192.168.1.50";
                  hostname = "idrac-poweredge";
                }
                {
                  hw-address = "a0:b3:cc:e3:25:2c";
                  ip-address = "192.168.1.51";
                }
                {
                  hw-address = "9c:b6:54:b1:32:c4";
                  ip-address = "192.168.1.52";
                }
                {
                  hw-address = "c8:cb:b8:c8:a3:46";
                  ip-address = "192.168.1.53";
                }
                {
                  hw-address = "fc:15:b4:8e:6e:a4";
                  ip-address = "192.168.1.54";
                }
                {
                  hw-address = "28:92:4a:34:f4:0c";
                  ip-address = "192.168.1.55";
                }
                # Server OSes
                # {
                #   hw-address = "28:80:23:a0:5b:c4";
                #   ip-address = "192.168.2.1";
                # }
                {
                  hw-address = "d8:9d:67:19:9f:70";
                  ip-address = "192.168.2.2";
                }
                {
                  hw-address = "ac:16:2d:70:bd:44";
                  ip-address = "192.168.2.3";
                }
                {
                  hw-address = "40:a8:f0:25:28:fc";
                  ip-address = "192.168.2.4";
                }
                {
                  hw-address = "ac:16:2d:8b:5d:b8";
                  ip-address = "192.168.2.5";
                }
              ];
            }
          ];
        };
      };
      dhcp6 = {
        enable = true;
        settings = {
          interfaces-config = {
            interfaces = [ config.homelab.router.devices.lan ];
          };
          lease-database = {
            name = "/var/lib/kea/dhcp6.leases";
            persist = true;
            type = "memfile";
          };
          rebind-timer = 2000;
          renew-timer = 1000;
          valid-lifetime = 4000;

          subnet6 = [
            {
              id = 2;
              pools = [ { pool = "2001:db8:1::1-2001:db8:1::ffff"; } ];
              subnet = config.homelab.router.kea.lanRange.ip6;
              interface = config.homelab.router.devices.lan;
            }
          ];
        };
      };
    };
  };
}
