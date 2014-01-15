# Add server operator.

define ngircd::oper(
  $password = undef,
  $mask = '*!*@*',
) {

  concat::fragment { "oper_${name}":
    target  => $::ngircd::param::config_file,
    content => template("${module_name}/oper.erb"),
    order   => '06',
  }

}
