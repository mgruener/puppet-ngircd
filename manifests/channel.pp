define ngircd::channel(
  $topic = undef,
  $modes = undef,
  $key = undef,
  $keyfile = undef,
  $max = 100,
) {

  concat::fragment { "chan_${name}":
    target  => $::ngircd::param::config_file,
    content => template("${module_name}/channel.erb"),
    order   => '08',
  }

}
