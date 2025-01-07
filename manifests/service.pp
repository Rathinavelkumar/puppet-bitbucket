# == Class: bitbucket::service
#
# This manages the bitbucket service. See README.md for details
#
class bitbucket::service  (

  Boolean $service_manage        = $bitbucket::service_manage,
  String $service_ensure        = $bitbucket::service_ensure,
  Boolean $service_enable        = $bitbucket::service_enable,
  $service_file_location = $bitbucket::params::service_file_location,
  $service_file_mode     = $bitbucket::params::service_file_mode,
  $service_file_template = $bitbucket::params::service_file_template,
  $service_lockfile      = $bitbucket::params::service_lockfile,

) {

  if $bitbucket::service_manage {
    file { $service_file_location:
      content => template($service_file_template),
      mode    => $service_file_mode,
    }

    exec { 'bitbucket_refresh_systemd':
      command     => 'systemctl daemon-reload',
      refreshonly => true,
      subscribe   => File[$service_file_location],
      require     => Exec['reload_bitbucket_units'],
      before      => Service['bitbucket'],
    }

    notify { 'Hello, Puppet!':
      message => 'This is a custom message logged during the Puppet run.',
    }

    service { 'bitbucket':
      ensure  => $service_ensure,
      enable  => $service_enable,
      provider  => 'systemd',
      require => File[$service_file_location],
    }
  }

}
