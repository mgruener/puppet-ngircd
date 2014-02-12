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
  $server_uid = $::ngircd::param::user,
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
  $cloak_user_to_nick = 'no',
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
  $ssl = false,
  $certfile = undef,
  $keyfile = undef,
  $keyfilepassword = undef,
  $ciphers = [ 'SECURE128' ],
  $dhfile = undef,
  $ssl_ports = [ ],
  $package_name = $::ngircd::param::package_name,
  $config_file = $::ngircd::param::config_file,
  $service_name = $::ngircd::param::service_name,
  $service_provider = $::ngircd::param::service_provider,
) inherits ngircd::param {

  $myclass = $module_name

  if !is_integer($connect_retry) { fail("${myclass}::connect_retry must be an integer and is set to <${connect_retry}>.") }
  if !is_integer($idle_timeout) { fail("${myclass}::idle_timeout must be an integer and is set to <${idle_timeout}>.") }
  if !is_integer($max_connections) { fail("${myclass}::max_connections must be an integer and is set to <${max_connections}>.") }
  if !is_integer($max_connections_ip) { fail("${myclass}::max_connections_ip must be an integer and is set to <${max_connections_ip}>.") }
  if !is_integer($max_joins) { fail("${myclass}::max_joins must be an integer and is set to <${max_joins}>.") }
  if !is_integer($max_nick_length) { fail("${myclass}::max_nick_length must be an integer and is set to <${max_nick_length}>.") }
  if !is_integer($max_list_size) { fail("${myclass}::max_list_size must be an integer and is set to <${max_list_size}>.") }
  if !is_integer($ping_timeout) { fail("${myclass}::ping_timeout must be an integer and is set to <${ping_timeout}>.") }
  if !is_integer($pong_timeout) { fail("${myclass}::pong_timeout must be an integer and is set to <${pong_timeout}>.") }

  if $help_file != undef { validate_absolute_path($help_file) }
  if $motd_file != undef { validate_absolute_path($motd_file) }
  if $pid_file != undef { validate_absolute_path($pid_file) }
  if $chroot_dir != undef { validate_absolute_path($chroot_dir) }
  if $include_dir != undef { validate_absolute_path($include_dir) }
  if $certfile != undef { validate_absolute_path($certfile) }
  if $keyfile != undef { validate_absolute_path($keyfile) }
  if $dhfile != undef { validate_absolute_path($dhfile) }
  if $config_file != undef {
    validate_absolute_path($config_file)
  } else {
    fail ("You have to provide ${myclass}::config_file.")
  }

  if $package_name == undef { fail("You have to provide ${myclass}::package_name.") }
  if $service_name == undef { fail("You have to provide ${myclass}::service_name.") }

  validate_re($ipv6, '^(yes|no)$', "${myclass}::ipv6 may be either 'yes' or 'no' and is set to <${ipv6}>.")
  validate_re($ipv4, '^(yes|no)$', "${myclass}::ipv4 may be either 'yes' or 'no' and is set to <${ipv4}>.")
  validate_re($dns, '^(yes|no)$', "${myclass}::dns may be either 'yes' or 'no' and is set to <${dns}>.")
  validate_re($ident, '^(yes|no)$', "${myclass}::ident may be either 'yes' or 'no' and is set to <${ident}>.")
  validate_re($allow_remote_op, '^(yes|no)$', "${myclass}::allow_remote_op may be either 'yes' or 'no' and is set to <${allow_remote_op}>.")
  validate_re($cloak_user_to_nick, '^(yes|no)$', "${myclass}::cloak_user_to_nick may be either 'yes' or 'no' and is set to <${cloak_user_to_nick}>.")
  validate_re($more_privacy, '^(yes|no)$', "${myclass}::more_privacy may be either 'yes' or 'no' and is set to <${more_privacy}>.")
  validate_re($notice_auth, '^(yes|no)$', "${myclass}::notice_auth may be either 'yes' or 'no' and is set to <${notice_auth}>.")
  validate_re($oper_can_use_mode, '^(yes|no)$', "${myclass}::oper_can_use_mode may be either 'yes' or 'no' and is set to <${oper_can_use_mode}>.")
  validate_re($oper_chanp_autoop, '^(yes|no)$', "${myclass}::oper_chanp_autoop may be either 'yes' or 'no' and is set to <${oper_chanp_autoop}>.")
  validate_re($oper_server_mode, '^(yes|no)$', "${myclass}::oper_server_mode may be either 'yes' or 'no' and is set to <${oper_server_mode}>.")
  validate_re($require_auth_ping, '^(yes|no)$', "${myclass}::require_auth_ping may be either 'yes' or 'no' and is set to <${require_auth_ping}>.")
  validate_re($scrub_ctcp, '^(yes|no)$', "${myclass}::scrub_ctcp may be either 'yes' or 'no' and is set to <${scrub_ctcp}>.")

  case type($ssl) {
    'string': {
      validate_re($ssl, '^(true|false)$', "${myclass}::ssl may be either 'true' or 'false' and is set to <${ssl}>.")
      $ssl_real = str2bool($ssl)
    }
    'boolean': {
      $ssl_real = $ssl
    }
    default: {
      fail("${myclass}::ssl type must be true or false.")
    }
  }

  package { $package_name:
    ensure => latest,
  }

  concat { $config_file:
    owner   => 'root',
    group   => $server_gid,
    mode    => '0660',
    warn    => true,
    require => Package[$package_name],
  }

  concat::fragment { 'main':
    target  => $config_file,
    order   => '01',
    content => template("${module_name}/global.erb"),
  }

  service { $service_name:
    ensure    => running,
    enable    => true,
    provider  => $service_provider,
    require   => [
      File[$config_file]
    ],
    subscribe => File[$config_file],
  }

}
