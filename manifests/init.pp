class infiniband (
  $map_ib='true',
  $ibnetworks={},
  $ibnetmask='255.255.252.0',
  $ibhosts={},
  $ibinterface='ib0'
) {
  if $vnic_interfaces != '' and $map_ib == 'true' {
    $vnics = split($vnic_interfaces, ',')
    infiniband::map_ib { $vnics:
      ibnetmask => $ibnetmask,
      ibnetworks => $ibnetworks,
      ibinterface => $ibinterface,
    }
  }
}
