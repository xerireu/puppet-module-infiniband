# Define: infiniband::hosts

define infiniband::hosts (
  $ibhosts,
) {
  validate_absolute_path($ibhosts)
  $hostdata = file($ibhosts)
  $temphosts = parsejson($hostdata)
  $hosts = delete($temphosts, $::hostname)
#  $hostdefaults = { 'require' => Infiniband::Netconf[$ibinterface] }
  create_resources('host', $hosts)
}
