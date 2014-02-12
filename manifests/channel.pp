define ngircd::channel(
  $topic = undef,
  $modes = undef,
  $key = undef,
  $keyfile = undef,
  $max = 100,
) {

  if $keyfile != undef { validate_absolute_path($keyfile) }
  if !is_integer($max) { fail("Parameter 'max' must be an integer and is set to <${max}>.") }

  concat::fragment { "chan_${name}":
    target  => $::ngircd::param::config_file,
    content => template("${module_name}/channel.erb"),
    order   => '08',
  }

}
