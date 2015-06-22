# == Class: infiniband
#
class infiniband (
  $map_ib      = true,
  $ibnetworks  = undef,
  $ibnetmask   = '255.255.252.0',
  $ibhosts     = undef,
  $ibinterface = 'ib0',
  $ibhosts     = '',
) {

  if type($map_ib) == 'string' {
    $map_ib_real = str2bool($map_ib)
  } else {
    $map_ib_real = $map_ib
  }

  validate_bool($map_ib_real)
  validate_hash($ibnetworks)
  validate_string($ibnetmask) # TODO: replace with validate_re
  validate_string($ibinterface)

  if $::vnic_interfaces != '' and $map_ib_real == true {
    $vnics = split($::vnic_interfaces, ',')
    infiniband::map_ib { $vnics:
      ibnetmask   => $ibnetmask,
      ibnetworks  => $ibnetworks,
      ibinterface => $ibinterface,
    }
  }
}
