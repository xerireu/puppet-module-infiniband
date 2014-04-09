require 'ipaddr'

module Puppet::Parser::Functions
  newfunction(:to_ib_network, :type => :rvalue) do |args|
    public_ip = IPAddr.new(args[0])
    ib_net = IPAddr.new(args[1])
    netmask = IPAddr.new(args[2])
    hostpart = ~netmask&public_ip
    ip_ib = ib_net|hostpart
  end
end
