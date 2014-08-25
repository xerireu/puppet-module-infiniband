# Define: infiniband::netconf

define infiniband::netconf (
  $ip,
  $netmask,
  $interface='',
) {
  if !$interface {
    $rinterface = $title
  } else {
    $rinterface = $interface
  }
  if $::osfamily == 'Suse' {
    file { "/etc/sysconfig/network/ifcfg-${rinterface}":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "BOOTPROTO='static'\nSTARTMODE='auto'\nUSERCONTROL='no'\nIPADDR=\"${ip}\"\nNETMASK=\"${netmask}\"\n",
      notify  => Exec["suse-infiniband-ifup-${rinterface}"],
    }
    exec { "suse-infiniband-ifup-${rinterface}":
      command     => "/sbin/ifup ${rinterface}",
      refreshonly => true,
    }
  }
  else {
    network::if::static { $rinterface:
      ensure    => 'up',
      ipaddress => $ip,
      netmask   => $netmask,
    }
  }
}
