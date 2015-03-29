class dovecot::master (
  $default_login_user     = undef,
  $default_internal_user  = undef,
  $service                = undef,
) {

  if $default_login_user != undef {
    validate_string($default_login_user)
  }

  if $default_internal_user != undef {
    validate_string($default_internal_user)
  }

  if $service != undef {
    validate_hash($service)
  }

  file { "${dovecot::confdir_real}/conf.d/10-master.conf":
    ensure  => 'file',
    owner   => $dovecot::user,
    group   => $dovecot::group,
    content => template('dovecot/10-master.conf.erb'),
    notify  => Service["${dovecot::service_name_real}"],
    require => Package["${dovecot::package_name_real}"],
  }
}
