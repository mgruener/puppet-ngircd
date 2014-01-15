# == Class: ngircd
#
# Full description of class ngircd here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { ngircd:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2014 Your name here, unless otherwise noted.
#
class ngircd(
  $server_name = $::fqdn,
  $ports = [ 6667, 6668 ],
  $info = '',
  $motd = '',
  $ipv6 = 'yes',
  $ipv4 = 'yes',
  $allowed_channel_types = '#',
  $dns = 'yes',
) inherits ngircd::param {

  package { $::ngircd::param::package_name:
    ensure => latest,
  }

  concat { $::ngircd::param::config_file:
    owner   => 'root',
    group   => $::ngircd::param::group,
    mode    => '0660',
    warn    => true,
    require => Package[$::ngircd::param::package_name],
  }

  concat::fragment { 'main':
    target  => $::ngircd::param::config_file,
    order   => '01',
    content => template("${module_name}/global.erb"),
  }

  service { $::ngircd::param::service_name:
    ensure    => running,
    enable    => true,
    require   => [
      File[$::ngircd::param::config_file]
    ],
    subscribe => File[$::ngircd::param::config_file],
  }

}
