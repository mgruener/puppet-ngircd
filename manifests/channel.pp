define ngircd::channel(
  $topic = undef,
  $modes = undef,
  $key = undef,
  $keyfile = undef,
  $max = 100,
  $config_file = getvar('ngircd::config_file'),
) {
  include ngircd

  if $keyfile != undef { validate_absolute_path($keyfile) }
  if !is_integer($max) { fail("Parameter 'max' must be an integer and is set to <${max}>.") }

  if $config_file != undef {
    validate_absolute_path($config_file)
  } else {
    fail ('You have to provide a config_file.')
  }

  concat::fragment { "chan_${name}":
    target  => $config_file,
    content => template("${module_name}/channel.erb"),
    order   => '08',
  }

}
