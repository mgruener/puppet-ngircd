# Add server operator.

define ngircd::oper(
  $password = undef,
  $mask = '*!*@*',
  $config_file = $ngircd::config_file,
) {
  include ngircd

  if $config_file != undef {
    validate_absolute_path($config_file)
  } else {
    fail ('You have to provide a config_file.')
  }

  concat::fragment { "oper_${name}":
    target  => $config_file,
    content => template("${module_name}/oper.erb"),
    order   => '06',
  }

}
