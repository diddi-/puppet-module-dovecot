class dovecot (
  $confdir            = 'USE_DEFAULTS',
  $enable_imap        = 'false',
  $group              = 'dovecot',
  $listen             = ['*', '::'],
  $package_name       = 'USE_DEFAULTS',
  $package_name_ldap  = 'USE_DEFAULTS',
  $package_name_imap  = 'USE_DEFAULTS',
  $service_name       = 'USE_DEFAULTS',
  $user               = 'dovecot',
) {

  case $::operatingsystem {
    'Debian': {
      $default_package_name = 'dovecot-core'
      $default_package_name_ldap = 'dovecot-ldap'
      $default_package_name_imap = 'dovecot-imapd'
      $default_service_name = 'dovecot'
      $default_confdir = '/etc/dovecot/'
      $default_user = 'dovecot'
      $default_group = 'dovecot'
    }

    default: {
      fail("Unsupported operating system '$::operatingsystem'.")
    }
  }

  if $confdir == 'USE_DEFAULTS' {
    $confdir_real = $default_confdir
  } else {
    $confdir_real = $confdir
  }

  if is_string($enable_imap) == true {
    $enable_imap_real = str2bool($enable_imap)
  } else {
    $enable_imap_real = $enable_imap
  }
  validate_bool($enable_imap_real)

  if $package_name == 'USE_DEFAULTS' {
    $package_name_real = $default_package_name
  } else {
    $package_name_real = $package_name
  }

  if $package_name_ldap == 'USE_DEFAULTS' {
    $package_name_ldap_real = $default_package_name_ldap
  } else {
    $package_name_ldap_real = $package_name_ldap
  }

  if $package_name_imap == 'USE_DEFAULTS' {
    $package_name_imap_real = $default_package_name_imap
  } else {
    $package_name_imap_real = $package_name_imap
  }
 
  if $service_name == 'USE_DEFAULTS' {
    $service_name_real = $default_service_name
  } else {
    $service_name_real = $service_name
  }

  package { "$package_name_real": 
    ensure => 'installed',
  }
  
  service { "$service_name_real":
    ensure   => 'running',
    enable   => true,
    require  => Package[$package_name_real],
  }

  include dovecot::auth
  include dovecot::mail
  include dovecot::master
  include dovecot::ssl
  if $enable_imap_real == true {
    include dovecot::imap
  }


}
