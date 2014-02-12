# Define our peer (irc server)

define ngircd::server(
  $host = $name,
  $port = 6667,
  $remote_password = undef,
  $local_password = undef,
  $bind = undef,
  $passive = 'no',
  $group = '1',
  $service_mask = undef,
  $ssl = 'no',
) {

  validate_re($ssl, '^(yes|no)$', "Parameter 'ssl' may be either 'yes' or 'no' and is set to <${ssl}>.")
  validate_re($passive, '^(yes|no)$', "Parameter 'passive' may be either 'yes' or 'no' and is set to <${passive}>.")
  if !is_integer($port) { fail("Parameter 'port' must be an integer and is set to <${port}>.") }

  concat::fragment { "server_${name}":
    target  => $::ngircd::param::config_file,
    content => template("${module_name}/server.erb"),
    order   => '05',
  }

}
