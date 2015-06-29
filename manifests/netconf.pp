# Define: infiniband::netconf

define infiniband::netconf (
  $ip,
  $netmask,
  $interface='',
  $bonding_master='',
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
  elsif $::osfamily == 'RedHat' {
    file { "/etc/sysconfig/network-scripts/ifcfg-${rinterface}":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => "DEVICE=${rinterface}\nBOOTPROTO=static\nONBOOT=yes\nHOTPLUG=yes\nIPADDR=${ip}\nNETMASK=${netmask}\nNM_CONTROLLED=no\n",
      notify  => Exec["rhel-infiniband-ifup-${rinterface}"],
    }
    exec { "rhel-infiniband-ifup-${rinterface}":
      command     => "/sbin/ifup ${rinterface}",
      refreshonly => true,
    }
  }
}
