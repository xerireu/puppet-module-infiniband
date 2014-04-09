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
  $_net_eval = "network_${real_interface}"
  $_mask_eval = "netmask_${real_interface}"
  $_ip_eval = "ipaddress_${real_interface}"
  $vnic_network = inline_template("<%= scope.lookupvar(@_net_eval) %>")
  $vnic_netmask = inline_template("<%= scope.lookupvar(@_mask_eval) %>")
  $vnic_ip = inline_template("<%= scope.lookupvar(@_ip_eval) %>")
  
  $ipnmask = $ibnetworks[$vnic_network]
  if $ipnmask {
    $ib_net = $ipnmask[0]
    $ib_mask = $ipnmask[1]
    $ib_ip = to_ib_network($vnic_ip, $ib_net, $vnic_netmask)
    network::if::static { "$ibinterface":
      ipaddress => $ib_ip,
      netmask => $ib_mask,
      ensure => 'up',
    }
  }

}
