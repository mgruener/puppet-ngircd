# == Class: ngircd
#
# ngircd class installs, configures and starts ngircd service.
#
# === Parameters
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
#    ports => [ 6667, 6668 ],
#  }
#
# === Authors
#
# Marius Karnauskas <marius@karnauskas.lt>
#
# === Copyright
#
# Copyright 2014 Marius Karnauskas
#
class ngircd(
  $server_name = $::fqdn,
  $ports = [ 6667 ],
  $info = '',
  $motd = '',
  $ipv6 = 'yes',
  $ipv4 = 'yes',
  $allowed_channel_types = '#',
  $dns = 'yes',
  $help_file = '/usr/share/doc/ngircd-21/Commands.txt',
  $ident = 'yes',
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
    provider  => $::ngircd::param::service_provider,
    require   => [
      File[$::ngircd::param::config_file]
    ],
    subscribe => File[$::ngircd::param::config_file],
  }

}
