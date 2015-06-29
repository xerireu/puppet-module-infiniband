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
Path to json file containing resource definitions for hosts to be added on host where IPoIB is managed by this module

- *Default*: ''

ibinterface
-------------
Default IPoIB interface to map address to.

- *Default*: ib0
