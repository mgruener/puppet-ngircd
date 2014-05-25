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
  $config_file = $ngircd::config_file,
) {
  include ngircd

  validate_re($ssl, '^(yes|no)$', "Parameter 'ssl' may be either 'yes' or 'no' and is set to <${ssl}>.")
  validate_re($passive, '^(yes|no)$', "Parameter 'passive' may be either 'yes' or 'no' and is set to <${passive}>.")
  if !is_integer($port) { fail("Parameter 'port' must be an integer and is set to <${port}>.") }

  if $config_file != undef {
    validate_absolute_path($config_file)
  } else {
    fail ('You have to provide a config_file.')
  }

  concat::fragment { "server_${name}":
    target  => $config_file,
    content => template("${module_name}/server.erb"),
    order   => '05',
  }

}
