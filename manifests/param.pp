# Parameters for ngircd

class ngircd::param(
) {

  case $::osfamily {
    'RedHat': {
      $service_name = 'ngircd'
      $package_name = 'ngircd'
      $config_file = '/etc/ngircd.conf'
      $group = 'ngircd'
    }
    default: {
      fail("${::operatingsystem} is not supported yet.")
    }
  }

}
