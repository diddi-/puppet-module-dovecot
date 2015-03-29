class dovecot::ssl (
  $enable    = 'yes',
  $ssl_cert  = undef,
  $ssl_key   = undef,
) {

  validate_re($enable, '^(yes|no|required)$', "Invalid value '$enable' in dovecot::ssl::enable. Must be 'yes', 'no' or 'required'")

  if $ssl_cert != undef {
    validate_absolute_path($ssl_cert)
  }

  if $ssl_key != undef {
    validate_absolute_path($ssl_key)
  }

  if $enable != 'no' and ($ssl_cert == undef or $ssl_key == undef) {
    fail("dovecot::ssl::ssl_cert and dovecot::ssl::ssl_key must be set when dovecot::ssl::enable is '$enable'.")
  }

  file { "${dovecot::confdir_real}/conf.d/10-ssl.conf":
    ensure  => 'file',
    owner   => $dovecot::user,
    group   => $dovecot::group,
    content => template('dovecot/10-ssl.conf.erb'),
    notify  => Service["${dovecot::service_name_real}"],
    require => Package["${dovecot::package_name_real}"],
  }
}
