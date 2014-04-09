# I'm not a ruby programmer.

Facter.add("vnic_interfaces") do
  confine :kernel => "Linux"
  setcode do
    ifaces = []
    raw_ifaces = []
    bond_ifaces = []
    vlan_ifaces = []
    Dir.foreach("/sys/class/net") { |ifd|
      ethtool_output = Facter::Util::Resolution.exec("ethtool -i #{ifd} 2>/dev/null")
      if not ethtool_output then
        next
      end
      ethtool_output.each_line { |ethtool_line|
        key, val = ethtool_line.chomp.split(": ", 2)
        if key == "driver" and val == "xsvnic" then
          raw_ifaces.push(ifd)
        end
      }
    }
    ifaces = ifaces + raw_ifaces
    raw_ifaces.each { |iface|
      if File.symlink?("/sys/class/net/#{iface}/master") then
        bondif = File.basename(File.readlink("/sys/class/net/#{iface}/master"))
        bond_ifaces.push(bondif)
        ifaces.delete(iface)
      end
    }
    ifaces = ifaces + bond_ifaces
    if File.exists?("/proc/net/vlan/config") then
      ifaces_todel = []
      IO.foreach("/proc/net/vlan/config") { |vcline|
        vif, vid, rif = vcline.delete(" ").chomp.split("|", 3)
        if ifaces.include?(rif) then
          ifaces_todel.push(rif)
          ifaces.push(vif)
        end
      }
      ifaces_todel.each { |todel|
        ifaces.delete(todel)
      }
    end
    ifaces.uniq.join(",")
  end
end

Facter.add("ib_interfaces") do
  confine :kernel => "Linux"
  setcode do
    ifaces = []
    Dir.foreach("/sys/class/net") { |ifd|
      ethtool_output = Facter::Util::Resolution.exec("ethtool -i #{ifd} 2>/dev/null")
      if not ethtool_output then
        next
      end
      ethtool_output.each_line { |ethtool_line|
        key, val = ethtool_line.chomp.split(": ", 2)
        if key == "driver" and val == "ipoib" then
          ifaces.push(ifd)
        end
      }
    }
    ifaces.uniq.join(",")
  end
end
