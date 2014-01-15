# ssl configuration

define ngircd::ssl(
  $topic = undef,
  $modes = undef,
  $key = undef,
) inherits ngircd {

  concat::fragment { 'ssl':
    target  => $::ngircd::param::config_file,
    content => template("${module_name}/ssl.erb"),
    order   => '04',
  }

}
