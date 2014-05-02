# puppet-module-infiniband
===

[![Build Status](https://travis-ci.org/xerireu/puppet-module-infiniband.png?branch=master)](https://travis-ci.org/xerireu/puppet-module-infiniband)

This modules manages hosts in a infiniband network with both IPoIB Xsigo virtual ethernet interfaces 

===

# Compatibility
---------------
This module is built for use with Puppet v3 with Ruby versions 1.8.7, 1.9.3, and 2.0.0 on the following OS families.

* RedHat

===

# Parameters
------------

map_ib
-------------
Boolean to enable ip mapping between xsigo vnics and IPoIB interface.

- *Default*: true

ibnetworks
-------------
Hash of mapping between vnic networks and the IPoIB network.

- *Default*: undef

ibnetmask
-------------
Netmask of IPoIB network.

- *Default*: 255.255.252.0

ibhosts
-------------
Hash of hostnames with IPoIB addresses that should be added to /etc/hosts (not implemented yet).

- *Default*: undef

ibinterface
-------------
Default IPoIP interface to map address to.

- *Default*: ib0
