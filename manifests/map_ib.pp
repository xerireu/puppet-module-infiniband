# Define: infiniband::map_ib

define infiniband::map_ib (
  $interface='',
  $ibinterface='ib0',
  $rpfilter='0',
  $ibnetmask='255.255.252.0',
  $ibnetworks={},
) {

  if $interface != '' {
    $real_interface = $interface
  }
  else {
    $real_interface = $title
  }

  validate_string($real_interface)
  validate_string($ibinterface)
  validate_string($rpfilter)
  validate_string($ibnetmask)
  validate_hash($ibnetworks)

  $_net_eval = "network_${real_interface}"
  $_mask_eval = "netmask_${real_interface}"
  $_ip_eval = "ipaddress_${real_interface}"
  $vnic_network = inline_template('<%= scope.lookupvar(@_net_eval) %>')
  $vnic_netmask = inline_template('<%= scope.lookupvar(@_mask_eval) %>')
  $vnic_ip = inline_template('<%= scope.lookupvar(@_ip_eval) %>')

  $ipnmask = $ibnetworks[$vnic_network]
  if $ipnmask {
    $ib_net = $ipnmask[0]
    $ib_mask = $ipnmask[1]
    $ib_ip = to_ib_network($vnic_ip, $ib_net, $vnic_netmask)

    if !defined(Network::If::Static[$ibinterface]) {
      if $::osfamily == 'Suse' {
        file { "/etc/sysconfig/network/ifcfg-${ibinterface}":
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
          content => "BOOTPROTO='static'\nSTARTMODE='auto'\nUSERCONTROL='no'\nIPADDR=\"${ib_ip}\"\nNETMASK=\"${ib_mask}\"\n",
          notify  => Exec["suse-infiniband-ifup-${ibinterface}"],
        }
        exec { "suse-infiniband-ifup-${ibinterface}":
          command     => "/sbin/ifup ${ibinterface}",
          refreshonly => true,
        }
      }
      else {
        network::if::static { $ibinterface:
          ensure    => 'up',
          ipaddress => $ib_ip,
          netmask   => $ib_mask,
        }
      }
    }
  }

}
