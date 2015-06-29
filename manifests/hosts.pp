# Define: infiniband::hosts

define infiniband::hosts (
  $ibhosts,
) {
  $hostdata = file($ibhosts)
  $temphosts = parsejson($hostdata)
  $hosts = delete($temphosts, $::hostname)
  create_resources('host', $hosts)
}
