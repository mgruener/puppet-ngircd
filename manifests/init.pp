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
  $admin_info1 = undef,
  $admin_info2 = undef,
  $admin_email = undef,
  $listen = '127.0.0.1',
  $motd_file = undef,
  $password = undef,
  $pid_file = '/var/run/ngircd/ngircd.pid',
  $server_sid = $::ngircd::param::user,
  $server_gid = $::ngircd::param::group,
  $network = 'abba',
  $connect_retry = 60,
  $idle_timeout = 0,
  $max_connections = 0,
  $max_connections_ip = 5,
  $max_joins = 10,
  $max_nick_length = 9,
  $max_list_size = 100,
  $ping_timeout = 120,
  $pong_timeout = 20,
  $allow_remote_op = 'no',
  $chroot_dir = undef,
  $cloak_host = undef,
  $cloak_host_modex = undef,
  $cloak_host_salt = undef,
  $cload_user_to_nick = 'no',
  $user_modes = undef,
  $include_dir = '/etc/ngircd.conf.d',
  $more_privacy = 'no',
  $notice_auth = 'no',
  $oper_can_use_mode = 'no',
  $oper_chanp_autoop = 'yes',
  $oper_server_mode = 'no',
  $require_auth_ping = 'no',
  $scrub_ctcp = 'no',
  $syslog_facility = 'local5',
  $webirc_password = undef,
  $ssl_enabled = false,
  $certfile = undef,
  $keyfile = undef,
  $keyfilepassword = undef,
  $ciphers = [ 'SECURE128' ],
  $dhfile = undef,
  $ssl_ports = [ ],
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
