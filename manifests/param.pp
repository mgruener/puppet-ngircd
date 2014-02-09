# Parameters for ngircd

class ngircd::param(
) {

  case $::osfamily {
    'RedHat': {
      $package_name = 'ngircd'
      $config_file = '/etc/ngircd.conf'
      $group = 'ngircd'
    }
    default: {
      fail("${::operatingsystem} is not supported yet.")
    }
  }

  case $::operatingsystem {
    'Fedora': { $service_name = 'ngircd.service'
                $service_provider = systemd
    }
    default: {  $service_name = 'ngircd'
                $service_provider = undef
    }
  }

}
